//
//  MidiEventUserData.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/05.
//  Copyright © 2017年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

public final class MidiEventUserData: MidiEvent {
    
    private let _musicEventUserData: MusicEventUserData
    
    init(eventInfo: MidiEventInfo, musicEventUserData: MusicEventUserData) {
        self._musicEventUserData = musicEventUserData
        super.init(eventInfo: eventInfo)
    }
    
    public var length: UInt32 {
        return _musicEventUserData.length
    }
    
    public var data: (UInt8) {
        return _musicEventUserData.data
    }
}
