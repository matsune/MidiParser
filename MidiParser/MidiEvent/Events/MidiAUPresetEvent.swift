//
//  MidiAUPresetEvent.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/05.
//  Copyright © 2017年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

public final class MidiAUPresetEvent: MidiEvent {
    private let _auPresetEvent: AUPresetEvent
    
    init(eventInfo: MidiEventInfo, auPresetEvent: AUPresetEvent) {
        _auPresetEvent = auPresetEvent
        super.init(eventInfo: eventInfo)
    }
    
    public var scope: AudioUnitScope {
        return _auPresetEvent.scope
    }
    
    public var element: AudioUnitElement {
        return _auPresetEvent.element
    }
    
    public var preset: Unmanaged<CoreFoundation.CFPropertyList> {
        return _auPresetEvent.preset
    }
}
