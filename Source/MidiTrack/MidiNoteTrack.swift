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
    let _musicTrack: MusicTrack
    let iterator: EventIterator
    
    public private(set) var notes: [MidiNote] = [] {
        didSet {
            if isReload {
                return
            }
            
            notes.sort(by: { $0.timeStamp < $1.timeStamp })
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
    
//    public private(set) var channels: [MIDIChannelMessage] = []
//    public private(set) var patch = MidiPatch(program: 0)
    
    public var trackName = "" {
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
            add(metaEvent: MetaEvent(timeStamp: 0, metaType: .sequenceTrackName, bytes: Bytes(trackName.utf8)))
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
    
    init(musicTrack: MusicTrack) {
        _musicTrack = musicTrack
        iterator = EventIterator(track: musicTrack)
        reload()
    }
    
    private var isReload = false
    
    func reload() {
        isReload = true
        defer {
            isReload = false
        }
        
        notes.removeAll()
        keySignatures.removeAll()
        lyrics.removeAll()
        trackName = ""
        
        iterator.enumerate { eventInfo, _, _ in
            guard let eventData = eventInfo.data,
                let eventType = MidiEventType(eventInfo.type) else {
                return
            }
            
            switch eventType {
            case .midiNoteMessage:
                let noteMessage = eventData.load(as: MIDINoteMessage.self)
                let note = MidiNote(timeStamp: eventInfo.timeStamp,
                                    duration: noteMessage.duration,
                                    note: noteMessage.note,
                                    velocity: noteMessage.velocity,
                                    channel: noteMessage.channel,
                                    releaseVelocity: noteMessage.releaseVelocity)
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
                    trackName = data.string
                case .lyric:
                    lyrics.append(MidiLyric(timeStamp: eventInfo.timeStamp, str: data.string))
                default:
                    break
                }
            default:
                break
            }
        }
    }
    
    public func addNote(timeStamp: MusicTimeStamp,
                        duration: Float32,
                        note: UInt8,
                        velocity: UInt8,
                        channel: UInt8,
                        releaseVelocity: UInt8 = 0) {
        var message = MIDINoteMessage(channel: channel,
                                      note: note,
                                      velocity: velocity,
                                      releaseVelocity: releaseVelocity,
                                      duration: duration)
        let note = MidiNote(timeStamp: timeStamp,
                            duration: duration,
                            note: note,
                            velocity: velocity,
                            channel: channel,
                            releaseVelocity: releaseVelocity)
        check(MusicTrackNewMIDINoteEvent(_musicTrack, timeStamp, &message), label: "MusicTrackNewMIDINoteEvent")
        notes.append(note)
    }
    
    public func add(note: MidiNote) {
        var message = MIDINoteMessage(channel: note.channel,
                                      note: note.note,
                                      velocity: note.velocity,
                                      releaseVelocity: note.releaseVelocity,
                                      duration: note.duration)
        check(MusicTrackNewMIDINoteEvent(_musicTrack, note.timeStamp, &message), label: "MusicTrackNewMIDINoteEvent")
        notes.append(note)
    }
    
    public func removeNote(at index: Int) {
        let note = notes.remove(at: index)
        iterator.enumerate(seekTime: note.timeStamp) { info, finished, _ in
            if info.type == kMusicEventType_MIDINoteMessage,
                let noteMessage = info.data?.load(as: MIDINoteMessage.self),
                note.convert() == noteMessage {
                iterator.deleteEvent()
                finished = true
            }
        }
    }
    
    func cut(from inStartTime: MusicTimeStamp, to inEndTime: MusicTimeStamp) {
        check(MusicTrackCut(_musicTrack, inStartTime, inEndTime), label: "MusicTrackCut")
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
        return lhs._musicTrack == rhs._musicTrack
    }
}
