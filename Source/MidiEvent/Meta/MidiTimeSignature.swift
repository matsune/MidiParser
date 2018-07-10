//
//  MidiTimeSignature.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/10.
//  Copyright © 2017年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

public struct MidiTimeSignature: MetaEventProtocol {
    public let timeStamp: MusicTimeStamp
    // numerator / 2^denominator
    // ex.) 4/4 => numerator: 4, denominator: 2
    public let numerator: UInt8
    public let denominator: UInt8
    /// number of MIDI clocks in a metronome click
    public let cc: UInt8
    /// number of notated 32nd-notes in a MIDI quarter-note
    public let bb: UInt8
    
    var metaType: MetaEventType {
        return .timeSignature
    }
    
    var bytes: Bytes {
        return [numerator, denominator, cc, bb]
    }
}
