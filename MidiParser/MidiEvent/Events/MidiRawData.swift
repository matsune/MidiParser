//
//  MidiRawData.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/05.
//  Copyright © 2017年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

public final class MidiRawData: MidiEvent {
    private let _rawData: MIDIRawData
    
    init(eventInfo: MidiEventInfo, rawData: MIDIRawData) {
        _rawData = rawData
        super.init(eventInfo: eventInfo)
    }
    
    public var length: UInt32 {
        return _rawData.length
    }
    
    public var data: UInt8 {
        return _rawData.data
    }
}
