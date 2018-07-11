//
//  MidiLyric.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2018/07/11.
//  Copyright © 2018 Yuma Matsune. All rights reserved.
//

import AudioToolbox
import Foundation

public struct MidiLyric: MetaEventProtocol {
    public let timeStamp: MusicTimeStamp
    public let str: String
    
    var metaType: MetaEventType {
        return .lyric
    }
    
    var bytes: Bytes {
        return Bytes(str.utf8)
    }
}
