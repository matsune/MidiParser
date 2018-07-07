//
//  MidiChannelMessage.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/05.
//  Copyright © 2017年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

public final class MidiChannelMessage: MidiEvent {
    private let _channelMessage: MIDIChannelMessage
    
    init(eventInfo: MidiEventInfo, channelMessage: MIDIChannelMessage) {
        _channelMessage = channelMessage
        super.init(eventInfo: eventInfo)
    }
    
    public var status: UInt8 {
        return _channelMessage.status
    }
    
    public var data1: UInt8 {
        return _channelMessage.data1
    }
    
    public var data2: UInt8 {
        return _channelMessage.data2
    }
    
    public var reserved: UInt8 {
        return _channelMessage.reserved
    }
}
