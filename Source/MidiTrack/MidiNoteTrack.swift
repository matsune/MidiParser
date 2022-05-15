//
//  MidiNoteTrack.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/10.
//  Copyright © 2017年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

public final class MidiNoteTrack: MidiTrack {
    
    private var isReload = false
    private let beatsPerMinute: BeatsPerMinute
    private let ticksPerBeat: TicksPerBeat
    
    let musicTrack: MusicTrack
    let iterator: EventIterator
    
    private(set) var notes: [MidiNote] = [] {
        didSet {
            if isReload {
                return
            }
            
            notes.sort(by: { $0.timeStamp.inSeconds < $1.timeStamp.inSeconds })
        }
    }
        
    public var keySignatures: [MidiKeySignature] = [] {
        didSet {
            if isReload {
                return
            }
            
            var count = 0
            iterator.enumerate { info, finished, next in
                if let metaEvent = info.data?.assumingMemoryBound(to: MIDIMetaEvent.self).pointee,
                    MetaEventType(byte: metaEvent.metaEventType) == .keySignature {
                    iterator.deleteEvent()
                    next = false
                    count += 1
                }
                finished = count >= oldValue.count
            }
            keySignatures.forEach {
                add(metaEvent: $0)
            }
        }
    }
    
    public var lyrics: [MidiLyric] = [] {
        didSet {
            if isReload {
                return
            }
            
            var count = 0
            iterator.enumerate { info, finished, next in
                if let metaEvent: MIDIMetaEvent = bindEventData(info: info),
                    MetaEventType(byte: metaEvent.metaEventType) == .lyric {
                    iterator.deleteEvent()
                    next = false
                    count += 1
                }
                finished = count >= oldValue.count
            }
            lyrics.forEach {
                add(metaEvent: $0)
            }
        }
    }
    
    public var patch: MidiPatch? {
        didSet {
            if isReload {
                return
            }
            
            iterator.enumerate { info, finished, _ in
                if let metaEvent: MIDIChannelMessage = bindEventData(info: info),
                    metaEvent.status.hexString == "C" {
                    iterator.deleteEvent()
                    finished = true
                }
            }
            
            if let patch = patch {
                add(patch: patch)
            }
        }
    }
    
    public var name = "" {
        didSet {
            if isReload {
                return
            }
            
            iterator.enumerate { info, finished, _ in
                guard let metaEvent: MIDIMetaEvent = bindEventData(info: info),
                    MetaEventType(byte: metaEvent.metaEventType) == .sequenceTrackName else {
                    return
                }
                iterator.deleteEvent()
                finished = true
            }
            add(metaEvent: MetaEvent(timeStamp: 0, metaType: .sequenceTrackName, bytes: Bytes(name.utf8)))
        }
    }
    
    public var isMute: Bool {
        get {
            var data = false
            getProperty(.muteStatus, data: &data)
            return data
        }
        set {
            var data = newValue
            setProperty(.muteStatus, data: &data)
        }
    }
    
    public var isSolo: Bool {
        get {
            var data = false
            getProperty(.soloStatus, data: &data)
            return data
        }
        set {
            var data = newValue
            setProperty(.soloStatus, data: &data)
        }
    }
    
    public var offsetTime: MusicTimeStamp {
        get {
            var data: MusicTimeStamp = 0
            getProperty(.offsetTime, data: &data)
            return data
        }
        set {
            var data = newValue
            setProperty(.offsetTime, data: &data)
        }
    }
    
    public var trackLength: MusicTimeStamp {
        get {
            var data: MusicTimeStamp = 0
            getProperty(.trackLength, data: &data)
            return data
        }
        set {
            var data = newValue
            setProperty(.trackLength, data: &data)
        }
    }
    
    public var loopInfo: MusicTrackLoopInfo {
        get {
            var data = MusicTrackLoopInfo(loopDuration: 0, numberOfLoops: 1)
            getProperty(.loopInfo, data: &data)
            return data
        }
        set {
            var data = newValue
            setProperty(.loopInfo, data: &data)
        }
    }
    
    public var automatedParameters: UInt32 {
        get {
            var data: UInt32 = 0
            getProperty(.automatedParameters, data: &data)
            return data
        }
        set {
            var data = newValue
            setProperty(.automatedParameters, data: &data)
        }
    }
    
    init(musicTrack: MusicTrack, beatsPerMinute: BeatsPerMinute = BeatsPerMinute.regular, ticksPerBeat: TicksPerBeat = TicksPerBeat.regular) {
        self.beatsPerMinute = beatsPerMinute
        self.ticksPerBeat = ticksPerBeat
        self.musicTrack = musicTrack
        iterator = EventIterator(track: musicTrack)
        reload()
    }
}

extension MidiNoteTrack {
    
    func reload() {
        isReload = true
        defer {
            isReload = false
        }
        
        notes.removeAll()
        keySignatures.removeAll()
        lyrics.removeAll()
        name = ""
        
        iterator.enumerate { eventInfo, _, _ in
            guard let eventData = eventInfo.data,
                let eventType = MidiEventType(eventInfo.type) else {
                    return
            }
            
            switch eventType {
            case .noteMessage:
                let noteMessage = eventData.load(as: MIDINoteMessage.self)
                let note = MidiNote(regularTimeStamp: eventInfo.timeStamp,
                                    regularDuration: noteMessage.duration,
                                    note: noteMessage.note,
                                    velocity: noteMessage.velocity,
                                    channel: noteMessage.channel,
                                    releaseVelocity: noteMessage.releaseVelocity, beatsPerMinute: beatsPerMinute, ticksPerBeat: ticksPerBeat)
                notes.append(note)
            case .meta:
                let header = eventData.assumingMemoryBound(to: MetaEventHeader.self).pointee
                var data: Bytes = []
                for i in 0 ..< Int(header.dataLength) {
                    data.append(
                        eventData
                            .advanced(by: MemoryLayout<MetaEventHeader>.size)
                            .advanced(by: i)
                            .load(as: Byte.self)
                    )
                }
                
                guard let metaType = MetaEventType(byte: header.metaType) else {
                    return
                }
                
                switch metaType {
                case .keySignature:
                    // ex.) 0xFF 0x59 0x02 0x04(data[0]) 0x00(data[1])
                    // data[0] sf
                    // data[1] 0x00 => major, 0x01 => minor
                    let keySignature = MidiKeySignature(timeStamp: eventInfo.timeStamp,
                                                        sf: data[0],
                                                        isMajor: data[1] == 0)
                    keySignatures.append(keySignature)
                case .sequenceTrackName:
                    name = data.string
                case .lyric:
                    lyrics.append(MidiLyric(timeStamp: eventInfo.timeStamp, str: data.string))
                default:
                    break
                }
            case .channelMessage:
                if let channelMessage: MIDIChannelMessage = bindEventData(info: eventInfo),
                    let status = channelMessage.status.hexString.first,
                    let channel = channelMessage.status.hexString.suffix(1).number,
                    let gmPatch = GMPatch(rawValue: channelMessage.data1) {
                    switch status {
                    case "C":
                        patch = MidiPatch(channel: channel, patch: gmPatch)
                    default:
                        break
                    }
                }
            default:
                break
            }
        }
    }
}

//MARK: - Get
public extension MidiNoteTrack {
    
    func notes(from: MusicTimeStamp, to: MusicTimeStamp) -> [MidiNote] {
        return notes.filter { from ..< to ~= $0.timeStamp.inSeconds }
    }
    
}

//MARK: - Mutating
//MARK: - Add and Remove
public extension MidiNoteTrack {

    func addNote(timeStamp: MusicTimeStamp, duration: Float32, note: UInt8, velocity: UInt8, channel: UInt8, releaseVelocity: UInt8 = 0, beatsPerMinute: BeatsPerMinute = BeatsPerMinute.regular, ticksPerBeat: TicksPerBeat = TicksPerBeat.regular) {
        var message = MIDINoteMessage(channel: channel, note: note, velocity: velocity, releaseVelocity: releaseVelocity, duration: duration)
        let note = MidiNote(regularTimeStamp: timeStamp, regularDuration: duration, note: note, velocity: velocity, channel: channel, releaseVelocity: releaseVelocity, beatsPerMinute: beatsPerMinute, ticksPerBeat: ticksPerBeat)
        
        check(MusicTrackNewMIDINoteEvent(musicTrack, timeStamp, &message), label: "MusicTrackNewMIDINoteEvent")
        notes.append(note)
    }
    
    func add(note: MidiNote) {
        add(notes: [note])
    }

    func add(notes: [MidiNote]) {
        notes.forEach {
            var message = $0.convert()
            check(MusicTrackNewMIDINoteEvent(musicTrack, $0.timeStamp.inSeconds, &message), label: "MusicTrackNewMIDINoteEvent")
        }
        self.notes.append(contentsOf: notes)
    }
    
    func removeNote(at index: Int) {
        let note = notes.remove(at: index)
        iterator.enumerate(seekTime: note.timeStamp.inSeconds) { info, finished, _ in
            if info.type == kMusicEventType_MIDINoteMessage,
                let noteMessage = info.data?.load(as: MIDINoteMessage.self),
                note.convert() == noteMessage {
                iterator.deleteEvent()
                finished = true
            }
        }
    }
    
}

//MARK: - Clear
public extension MidiNoteTrack {
    
    func clearNotes(from: MusicTimeStamp, to: MusicTimeStamp) {
        iterator.enumerate(seekTime: from) { info, finished, next in
            if info.type == kMusicEventType_MIDINoteMessage,
                from ..< to ~= info.timeStamp {
                iterator.deleteEvent()
                next = false
            }
            finished = info.timeStamp >= to
        }
        notes = notes.filter { !(from ..< to ~= $0.timeStamp.inSeconds) }
    }
    
    func clearNotes() {
        var count = 0
        iterator.enumerate { info, finished, next in
            if let _: MIDINoteMessage = bindEventData(info: info) {
                iterator.deleteEvent()
                next = false
                count += 1
            }
            finished = count >= notes.count
        }
        notes.removeAll()
    }
}

//MARK: - Cut, Merge, Copy
public extension MidiNoteTrack {
    
    func cut(from inStartTime: MusicTimeStamp, to inEndTime: MusicTimeStamp) {
        check(MusicTrackCut(musicTrack, inStartTime, inEndTime), label: "MusicTrackCut", level: .log)
        reload()
    }
    
    func merge(from inStartTime: MusicTimeStamp, to inEndTime: MusicTimeStamp, destTrack: MidiNoteTrack, insertTime: MusicTimeStamp) {
        check(MusicTrackMerge(musicTrack, inStartTime, inEndTime, destTrack.musicTrack, insertTime),
              label: "MusicTrackMerge")
        destTrack.reload()
    }
    
    func copyInsert(from inStartTime: MusicTimeStamp, to inEndTime: MusicTimeStamp, destTrack: MidiNoteTrack, insertTime: MusicTimeStamp) {
        check(MusicTrackCopyInsert(musicTrack, inStartTime, inEndTime, destTrack.musicTrack, insertTime),
              label: "MusicTrackCopyInsert")
        destTrack.reload()
    }
    
}

extension MidiNoteTrack: RandomAccessCollection {
    public typealias Element = MidiNote
    public typealias Index = Int
    
    public subscript(position: Int) -> MidiNote {
        return notes[position]
    }
    
    public var startIndex: Int {
        return notes.startIndex
    }
    
    public var endIndex: Int {
        return notes.endIndex
    }
}

extension MidiNoteTrack: Equatable {
    public static func == (lhs: MidiNoteTrack, rhs: MidiNoteTrack) -> Bool {
        return lhs.musicTrack == rhs.musicTrack
    }
}
