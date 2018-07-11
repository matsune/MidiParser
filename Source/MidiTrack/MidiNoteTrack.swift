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
    
    public private(set) var notes: [MidiNote] {
        didSet {
            notes.sort(by: { $0.timeStamp < $1.timeStamp })
        }
    }
    
    public var keySignatures: [MidiKeySignature] {
        didSet {
            var count = 0
            iterator.enumerate { info, finished, next in
                if let metaEvent = info.data?.assumingMemoryBound(to: MIDIMetaEvent.self).pointee,
                    MetaEventType(byte: metaEvent.metaEventType) == .keySignature {
                    iterator.deleteEvent()
                    next = false
                    count += 1
                    finished = count >= oldValue.count
                }
            }
            keySignatures.forEach {
                add(metaEvent: $0)
            }
        }
    }
    
    public var lyrics: [MidiLyric] = [] {
        didSet {
            var count = 0
            iterator.enumerate { info, finished, next in
                guard let metaEvent: MIDIMetaEvent = bindEventData(info: info),
                    MetaEventType(byte: metaEvent.metaEventType) == .lyric else {
                    return
                }
                iterator.deleteEvent()
                next = false
                count += 1
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
    
    init(musicTrack: MusicTrack) {
        _musicTrack = musicTrack
        let iterator = EventIterator(track: musicTrack)
        self.iterator = iterator
        
        var name = ""
        var ns: [MidiNote] = []
        var keySigs: [MidiKeySignature] = []
        var lyrics: [MidiLyric] = []
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
                ns.append(note)
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
                    keySigs.append(keySignature)
                case .sequenceTrackName:
                    name = data.string
                case .lyric:
                    lyrics.append(MidiLyric(timeStamp: eventInfo.timeStamp, str: data.string))
                default:
                    break
                }
            //                case .midiChannelMessage:
            //                    let channelMessage = eventData.load(as: MIDIChannelMessage.self)
            //                    channels.append(channelMessage)
            //                    if channelMessage.status.hexString.first == "C" {
            //                        patch = MidiPatch(program: Int(channelMessage.data1))
            //                    }
            default:
                break
            }
        }
        trackName = name
        self.lyrics = lyrics
        notes = ns
        keySignatures = keySigs
    }
    
    public func add(timeStamp: MusicTimeStamp,
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
    
    public func deleteNote(at index: Int) {
        let note = notes.remove(at: index)
        iterator.delete(note: note)
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
