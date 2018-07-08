//
//  MidiEvent.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/04.
//  Copyright © 2017年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

public class MidiEvent: CustomDebugStringConvertible {
    let eventInfo: MidiEventInfo
    
    init(eventInfo: MidiEventInfo) {
        self.eventInfo = eventInfo
    }
    
    public var eventType: MidiEventType {
        return MidiEventType(eventInfo.type)!
    }
    
    public var timeStamp: MusicTimeStamp {
        return eventInfo.timeStamp
    }
    
    var dataSize: UInt32 {
        return eventInfo.dataSize
    }
    
    // - MARK: CustomDebugStringConvertible
    public var debugDescription: String {
        return "MidiEvent(eventType: \(eventType), timeStamp: \(timeStamp), dataSize: \(dataSize))"
    }
}
