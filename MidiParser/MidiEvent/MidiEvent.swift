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
    public let eventType: MidiEventType
    public let timeStamp: MusicTimeStamp
    public let dataSize: UInt32
    
    init(eventInfo: MidiEventInfo) {
        eventType = MidiEventType(eventInfo.type)!
        timeStamp = eventInfo.timeStamp
        dataSize = eventInfo.dataSize
    }
    
    // - MARK: CustomDebugStringConvertible
    public var debugDescription: String {
        return "MidiEvent(eventType: \(eventType), timeStamp: \(timeStamp), dataSize: \(dataSize))"
    }
}
