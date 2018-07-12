//
//  EventIterator.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/04.
//  Copyright © 2017年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

final class EventIterator {
    private let _iterator: MusicEventIterator
    
    init(track: MusicTrack) {
        var iterator: MusicEventIterator?
        check(NewMusicEventIterator(track, &iterator), label: "NewMusicEventIterator")
        
        guard let eventIterator = iterator else {
            fatalError("Could not initialize MusicEventIterator")
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
    
    var currentEvent: EventInfo? {
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
        return EventInfo(type: eventType, timeStamp: eventTimeStamp, data: eventData, dataSize: eventDataSize)
    }
    
    func seek(in timestamp: MusicTimeStamp) {
        check(MusicEventIteratorSeek(_iterator, timestamp), label: "MusicEventIteratorSeek")
    }
    
    /// Enumerate events from `seekTime` to end of track.
    /// Need to set `next` flag false when you called `deleteEvent()` during block
    /// because pointer move forward after delete.
    ///
    /// - parameter seekTime: start time
    /// - parameters:
    ///     - info: current event
    ///     - finished: flag to break loop
    ///     - next: flag whether do `nextEvent()`
    func enumerate(seekTime: MusicTimeStamp = 0,
                   block: (_ info: EventInfo, _ finished: inout Bool, _ next: inout Bool) -> Void) {
        seek(in: seekTime)
        while hasCurrentEvent {
            var finished: Bool = false
            var next: Bool = true
            
            if let info = currentEvent {
                block(info, &finished, &next)
            }
            if finished || !hasNextEvent { break }
            if next {
                nextEvent()
            }
        }
    }
    
    func deleteEvent() {
        check(MusicEventIteratorDeleteEvent(_iterator), label: "MusicEventIteratorDeleteEvent")
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
