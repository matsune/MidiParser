//
//  MidiKeySignature.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/10.
//  Copyright © 2017年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

public struct MidiKeySignature: MidiEventProtocol {
    public var timeStamp: MusicTimeStamp
    public var keySig: KeySignature
    
    public init(timeStamp: MusicTimeStamp, key: KeySignature) {
        self.timeStamp = timeStamp
        self.keySig = key
    }
    
    init(timeStamp: MusicTimeStamp, sf: UInt8, isMajor: Bool) {
        self.timeStamp = timeStamp
        if isMajor {
            self.keySig = .major(MajorKey(sf: sf))
        } else {
            self.keySig = .minor(MinorKey(sf: sf))
        }
    }
}
