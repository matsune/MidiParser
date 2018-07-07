//
//  MidiParameterEvent.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/05.
//  Copyright © 2017年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

public final class MidiParameterEvent: MidiEvent {
    private let _parameterEvent: ParameterEvent
    
    init(eventInfo: MidiEventInfo, parameterEvent: ParameterEvent) {
        _parameterEvent = parameterEvent
        super.init(eventInfo: eventInfo)
    }
    
    public var parameterID: AudioUnitParameterID {
        return _parameterEvent.parameterID
    }
    
    public var scope: AudioUnitScope {
        return _parameterEvent.scope
    }
    
    public var element: AudioUnitElement {
        return _parameterEvent.element
    }
    
    public var value: AudioUnitParameterValue {
        return _parameterEvent.value
    }
}
