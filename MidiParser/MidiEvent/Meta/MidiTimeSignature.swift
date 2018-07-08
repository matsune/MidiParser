//
//  MidiTimeSignature.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/10.
//  Copyright © 2017年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

public struct MidiTimeSignature: MidiEventProtocol {
    public var timeStamp: MusicTimeStamp
    // numerator / denominator
    // ex.) 4/4
    public var numerator: Int
    public var denominator: Int
    /// number of MIDI clocks in a metronome click
    public var cc: Int
    /// number of notated 32nd-notes in a MIDI quarter-note
    public var bb: Int
    
    init(timeStamp: MusicTimeStamp, data: [Int]) {
        self.timeStamp = timeStamp
        numerator = data[0]
        let decimal = pow(Decimal(2), data[1])
        let num = NSDecimalNumber(decimal: decimal)
        denominator = Int(truncating: num)
        cc = data[2]
        bb = data[3]
    }
}
