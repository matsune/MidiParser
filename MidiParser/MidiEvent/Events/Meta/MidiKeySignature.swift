//
//  MidiKeySignature.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/10.
//  Copyright © 2017年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

public final class MidiKeySignature: MidiEvent, Equatable {
    public let keySignature: KeySignature
    
    init(eventInfo: MidiEventInfo, data: [Int]) {
        keySignature = KeySignature(data[0])
        super.init(eventInfo: eventInfo)
    }
    
    // - MARK: CustomDebugStringConvertible
    public override var debugDescription: String {
        return "MidiKeySignature(timeStamp: \(timeStamp), keySignature: \(keySignature))"
    }
    
    public static func == (lhs: MidiKeySignature, rhs: MidiKeySignature) -> Bool {
        return lhs.keySignature == rhs.keySignature
    }
    
    public static func != (lhs: MidiKeySignature, rhs: MidiKeySignature) -> Bool {
        return !(lhs == rhs)
    }
}
