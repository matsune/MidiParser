//
//  Ticks.swift
//  MidiParser iOS
//
//  Created by Vladimir Vybornov on 6/20/19.
//  Copyright © 2019 Yuma Matsune. All rights reserved.
//

import Foundation
import AVFoundation

extension Double {
    
    public func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
}

public struct Milliseconds {
    static let inMinute = 60_000
    static let inSecond = 1_000
    let value: Int
    
    init(_ value: Int) {
        self.value = value
    }
    
    init(_ value: Double) {
        let result = value * Double(Milliseconds.inSecond)
        self.value = Int(result.roundTo(places: 0))
    }
}

public extension Milliseconds {
    
    var seconds: Double {
        return Double(value) / Double(Milliseconds.inSecond)
    }
    
    func toTicks(forBeatsPerMinute bpm: BeatsPerMinute = BeatsPerMinute.regular, andTicksPerBeat tpb: TicksPerBeat = TicksPerBeat.regular) -> Ticks {
        let ms = Double(value)
        let ticks = ms / (Double(Milliseconds.inMinute) / Double(bpm.value * tpb.value))
        
        return Ticks(UInt(ticks.roundTo(places: 0)))
    }
}

public struct TicksPerBeat {
    public static let regular = TicksPerBeat(480)
    public let value: UInt

    public init(_ value: UInt) {
        self.value = value
    }
}

public struct BeatsPerMinute {
    public static let regular = BeatsPerMinute(60)
    public let value: UInt
    
    public init(_ value: UInt) {
        self.value = value
    }
}

public struct Ticks {
    public let value: UInt
    
    public init(_ value: UInt) {
        self.value = value
    }
    
    public func toMs(forBeatsPerMinute bpm: BeatsPerMinute = BeatsPerMinute.regular, andTicksPerBeat tpb: TicksPerBeat = TicksPerBeat.regular) -> Milliseconds {
        return Milliseconds(Int(Double(Milliseconds.inMinute) / Double(bpm.value * tpb.value) * Double(value)))
    }
}
