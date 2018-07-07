//
//  MidiExtendedNoteOnEvent.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/05.
//  Copyright © 2017年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

public final class MidiExtendedNoteOnEvent: MidiEvent {
    private let _extendedNoteOnEvent: ExtendedNoteOnEvent
    
    init(eventInfo: MidiEventInfo, extendedNoteOnEvent: ExtendedNoteOnEvent) {
        _extendedNoteOnEvent = extendedNoteOnEvent
        super.init(eventInfo: eventInfo)
    }
    
    public var instrumentID: MusicDeviceInstrumentID {
        return _extendedNoteOnEvent.instrumentID
    }
    
    public var groupID: MusicDeviceGroupID {
        return _extendedNoteOnEvent.groupID
    }
    
    public var duration: Float32 {
        return _extendedNoteOnEvent.duration
    }
    
    public var extendedParams: MusicDeviceNoteParams {
        return _extendedNoteOnEvent.extendedParams
    }
}
