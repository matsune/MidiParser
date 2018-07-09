//
//  MidiEventIterator.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/04.
//  Copyright © 2017年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

final class MidiEventIterator {
    private let _iterator: MusicEventIterator
    
    init(track: MusicTrack) {
        var iterator: MusicEventIterator?
        check(NewMusicEventIterator(track, &iterator), label: "NewMusicEventIterator")
        
        guard let eventIterator = iterator else {
            fatalError("Could not initialize MidiEventIterator")
        }
        _iterator = eventIterator
    }
    
    deinit {
        check(DisposeMusicEventIterator(_iterator),
              label: "DisposeMusicEventIterator", level: .log)
    }
    
    var hasNextEvent: Bool {
        var hasNextEvent: DarwinBoolean = false
        check(MusicEventIteratorHasNextEvent(_iterator, &hasNextEvent),
              label: "MusicEventIteratorHasNextEvent", level: .log)
        return hasNextEvent.boolValue
    }
    
    var hasCurrentEvent: Bool {
        var hasCurrentEvent: DarwinBoolean = false
        check(MusicEventIteratorHasCurrentEvent(_iterator, &hasCurrentEvent),
              label: "MusicEventIteratorHasCurrentEvent", level: .log)
        return hasCurrentEvent.boolValue
    }
    
    func nextEvent() {
        check(MusicEventIteratorNextEvent(_iterator), label: "MusicEventIteratorNextEvent")
    }
    
    func previousEvent() {
        check(MusicEventIteratorPreviousEvent(_iterator), label: "MusicEventIteratorPreviousEvent")
    }
    
    var currentEvent: MidiEventInfo? {
        var eventType: MusicEventType = 0
        var eventTimeStamp: MusicTimeStamp = -1
        var eventData: UnsafeRawPointer?
        var eventDataSize: UInt32 = 0
        if check(MusicEventIteratorGetEventInfo(_iterator,
                                                &eventTimeStamp,
                                                &eventType,
                                                &eventData,
                                                &eventDataSize),
                 label: "MusicEventIteratorGetEventInfo", level: .log) != noErr {
            return nil
        }
        return MidiEventInfo(type: eventType, timeStamp: eventTimeStamp, data: eventData, dataSize: eventDataSize)
    }
    
    func seek(in timestamp: MusicTimeStamp) {
        check(MusicEventIteratorSeek(_iterator, timestamp), label: "MusicEventIteratorSeek")
    }
    
    func enumerate(seekTime: MusicTimeStamp = 0, block: (MidiEventInfo?) -> Void) {
        seek(in: seekTime)
        while hasCurrentEvent {
            block(currentEvent)
            if !hasNextEvent { break }
            nextEvent()
        }
    }
    
    func deleteEvent() {
        check(MusicEventIteratorDeleteEvent(_iterator), label: "MusicEventIteratorDeleteEvent")
    }
    
    func delete(note: MidiNote) {
        enumerate(seekTime: note.timeStamp) { info in
            if let info = info,
                info.type == kMusicEventType_MIDINoteMessage,
                let noteMessage = info.data?.load(as: MIDINoteMessage.self),
                note.convert() == noteMessage {
                check(MusicEventIteratorDeleteEvent(_iterator), label: "MusicEventIteratorDeleteEvent")
            }
        }
    }
}

extension MIDINoteMessage: Equatable {
    public static func == (lhs: MIDINoteMessage, rhs: MIDINoteMessage) -> Bool {
        return lhs.channel == rhs.channel
            && lhs.duration == rhs.duration
            && lhs.note == rhs.note
            && lhs.releaseVelocity == rhs.releaseVelocity
            && lhs.velocity == rhs.velocity
    }
}
