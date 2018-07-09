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
    private var notes: [MidiNote] = [] {
        didSet {
            notes.sort(by: { $0.timeStamp < $1.timeStamp })
        }
    }
    
    public private(set) var keySignatures: [MidiKeySignature] = []
    public private(set) var channels: [MIDIChannelMessage] = []
    public private(set) var patch = MidiPatch(program: 0)
    public var sequenceTrackName = ""
    
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
    
    public private(set) var isDrumTrack = false
    
    override init(musicTrack: MusicTrack) {
        super.init(musicTrack: musicTrack)
        reloadEvents()
    }
    
    private func reloadEvents() {
        notes = []
        keySignatures = []
        channels = []
        
        iterator.enumerate { eventInfo in
            guard let eventInfo = eventInfo,
                let eventData = eventInfo.data else {
                fatalError("MidiNoteTrack error")
            }
            
            if let eventType = MidiEventType(eventInfo.type) {
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
                    // Channel 9 is reserved for the use with percussion instruments.
                    isDrumTrack = noteMessage.channel == 9
                case .meta:
                    let header = eventData.assumingMemoryBound(to: MetaEventHeader.self).pointee
                    var data: [UInt8] = []
                    for i in 0 ..< Int(header.dataLength) {
                        data.append(eventData.advanced(by: MemoryLayout<MetaEventHeader>.size).advanced(by: i).load(as: UInt8.self))
                    }
                    
                    if let metaType = MetaEventType(decimal: header.metaType) {
                        switch metaType {
                        case .keySignature:
                            // ex.) 0xFF 0x59 0x02 0x04(data[0]) 0x00(data[1])
                            // data[0] sf
                            // data[1] 0x00 => major, 0x01 => minor
                            let keySignature = MidiKeySignature(timeStamp: eventInfo.timeStamp, sf: data[0], isMajor: data[1] == 0)
                            keySignatures.append(keySignature)
                        case .sequenceTrackName:
                            sequenceTrackName = data.map { String(format: "%c", $0) }.reduce("", +)
                        default:
                            break
                        }
                    }
                case .midiChannelMessage:
                    let channelMessage = eventData.load(as: MIDIChannelMessage.self)
                    if channelMessage.status.hexString.first == "C" {
                        patch = MidiPatch(program: Int(channelMessage.data1))
                    }
                default:
                    break
                }
            }
        }
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
