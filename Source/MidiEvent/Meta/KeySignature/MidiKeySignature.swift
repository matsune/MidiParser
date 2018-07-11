//
//  MidiKeySignature.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/10.
//  Copyright © 2017年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

// 0xFF 0x59 0x02 0x[sf] 0x[ml]
public struct MidiKeySignature: MetaEventProtocol {
    public let timeStamp: MusicTimeStamp
    public let keySig: KeySignature
    
    public init(timeStamp: MusicTimeStamp, key: KeySignature) {
        self.timeStamp = timeStamp
        keySig = key
    }
    
    init(timeStamp: MusicTimeStamp, sf: UInt8, isMajor: Bool) {
        self.timeStamp = timeStamp
        if isMajor {
            keySig = .major(MajorKey(rawValue: sf) ?? .C)
        } else {
            keySig = .minor(MinorKey(rawValue: sf) ?? .A)
        }
    }
    
    var metaType: MetaEventType {
        return .keySignature
    }
    
    var bytes: Bytes {
        return keySig.bytes
    }
}
