//
//  Ticks.swift
//  MidiParser iOS
//
//  Created by Vladimir Vybornov on 6/20/19.
//  Copyright © 2019 Yuma Matsune. All rights reserved.
//

import Foundation
import AVFoundation

public typealias BeatsPerMinute = Int
public typealias TicksPerBeat = Int
public typealias Ticks = Int
public typealias Milliseconds = Int

extension Double {
    
    public func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
}

public extension Ticks {

    func toMilliseconds(forBeatsPerMinute bpm: BeatsPerMinute, andTicksPerBeat tpb: TicksPerBeat) -> Milliseconds {
        let msInMinute = 60_000.0
        return Int(msInMinute / Double(bpm * tpb) * Double(self))
    }

}

public extension MusicTimeStamp {
    
    var milliseconds: Milliseconds {
        return Milliseconds(self * 1_000)
    }
    
    func toTicks(forBeatsPerMinute bpm: BeatsPerMinute, andTicksPerBeat tpb: TicksPerBeat) -> Ticks {
        let msInMinute = 60_000.0
        let msInSecond = 1_000.0
        let ms = Double(msInSecond * self)
        let ticks = ms / (msInMinute / Double(bpm * tpb))
        
        return Ticks(ticks.roundTo(places: 0))
    }
}

public extension Milliseconds {
    
    func toTicks(forBeatsPerMinute bpm: BeatsPerMinute, andTicksPerBeat tpb: TicksPerBeat) -> Ticks {
        let msInMinute = 60_000.0
        let ms = Double(self)
        let ticks = ms / (msInMinute / Double(bpm * tpb))
        
        return Ticks(ticks.roundTo(places: 0))
    }
}
