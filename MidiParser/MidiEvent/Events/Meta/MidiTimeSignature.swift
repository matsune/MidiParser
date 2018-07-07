//
//  MidiTimeSignature.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/10.
//  Copyright © 2017年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

public final class MidiTimeSignature: MidiEvent, Equatable {
    // numerator / denominator
    // ex.) 4/4
    public let numerator: Int
    public let denominator: Int
    /// number of MIDI clocks in a metronome click
    public let cc: Int
    /// number of notated 32nd-notes in a MIDI quarter-note
    public let bb: Int
    
    convenience init(eventInfo: MidiEventInfo, data: [Int]) {
        self.init(eventInfo: eventInfo, numerator: data[0], denominator: data[1], cc: data[2], bb: data[3])
    }
    
    init(eventInfo: MidiEventInfo, numerator: Int, denominator: Int, cc: Int, bb: Int) {
        self.numerator = numerator
        let decimal = pow(Decimal(2), denominator)
        let num = NSDecimalNumber(decimal: decimal)
        self.denominator = Int(truncating: num)
        self.cc = cc
        self.bb = bb
        super.init(eventInfo: eventInfo)
    }
    
    // - MARK: CustomDebugStringConvertible
    public override var debugDescription: String {
        return "MidiTimeSignature(timeStamp: \(timeStamp), timeSignature: \(numerator)/\(denominator), cc: \(cc), bb: \(bb))"
    }
    
    public static func == (lhs: MidiTimeSignature, rhs: MidiTimeSignature) -> Bool {
        return lhs.numerator == rhs.numerator && lhs.denominator == rhs.denominator
    }
    
    public static func != (lhs: MidiTimeSignature, rhs: MidiTimeSignature) -> Bool {
        return !(lhs == rhs)
    }
}
