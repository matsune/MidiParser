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
            fatalError("MidiEventIterator error")
        }
        self._iterator = eventIterator
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
    
    func getCurrentEvent() -> MidiEventInfo? {
        var eventType: MusicEventType = 0
        var eventTimeStamp: MusicTimeStamp = -1
        var eventData: UnsafeRawPointer?
        var eventDataSize: UInt32 = 0
        if check(MusicEventIteratorGetEventInfo(_iterator,
                                                 &eventTimeStamp,
                                                 &eventType,
                                                 &eventData,
                                                 &eventDataSize),
                  label: "MusicEventIteratorGetEventInfo") != noErr {
            return nil
        }
        return MidiEventInfo(type: eventType, timeStamp: eventTimeStamp, data: eventData, dataSize: eventDataSize)
    }
}
