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
    public private(set) var notes: [MidiNoteEvent] = []
    public private(set) var keySignatures: [MidiKeySignature] = []
    public private(set) var channels: [MIDIChannelMessage] = []
    public private(set) var patch = MidiPatch(program: 0)
    
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
    
    public var offset: MusicTimeStamp {
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
    
    public var isDrumTrack = false
    
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
                    notes.append(MidiNoteEvent(eventInfo: eventInfo,
                                               midiNoteMessage: noteMessage))
                    // Channel 9 is reserved for the use with percussion instruments.
                    isDrumTrack = noteMessage.channel == 9
                case .meta:
                    var metaEvent = eventData.load(as: MIDIMetaEvent.self)
                    var data: [Int] = []
                    withUnsafeMutablePointer(to: &metaEvent.data) {
                        for i in 0 ..< Int(metaEvent.dataLength) {
                            data.append(Int($0.advanced(by: i).pointee))
                        }
                    }
                    if let metaType = MetaEventType(decimal: metaEvent.metaEventType) {
                        switch metaType {
                        case .keySignature:
                            keySignatures.append(MidiKeySignature(eventInfo: eventInfo, data: data))
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
    
    func deleteNote(at index: Int) {
        let note = notes.remove(at: index)
        iterator.delete(event: note)
    }
}
