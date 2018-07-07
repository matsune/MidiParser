//
//  MidiExtendedTempoEvent.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/05.
//  Copyright © 2017年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

public final class MidiExtendedTempoEvent: MidiEvent {
    private let _extendedTempoEvent: ExtendedTempoEvent
    
    init(eventInfo: MidiEventInfo, extendedTempoEvent: ExtendedTempoEvent) {
        _extendedTempoEvent = extendedTempoEvent
        super.init(eventInfo: eventInfo)
    }
    
    public var bpm: Float64 {
        return _extendedTempoEvent.bpm
    }
}
