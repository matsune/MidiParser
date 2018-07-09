//
//  KeySignature.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/08.
//  Copyright © 2017年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

// 0, 1, 2, 3, 4, 5, 6, 7, -1(255), -2, -3, -4, -5, -6, -7

public enum KeySignature: Equatable {
    case major(MajorKey)
    case minor(MinorKey)
}

private func sfToRawValue(_ sf: UInt8) -> Int {
    if 0...7 ~= sf {
        return Int(sf)
    } else if 249 ... 255 ~= sf {
        // 255 -> 8, 254 -> 9 ...
        return 263 - Int(sf)
    }
    return 0
}

public enum MajorKey: Int {
    case C, G, D, A, E, B, Fsharp, Csharp, F, Bflat, Eflat, Aflat, Dflat, Gflat, Cflat
    
    init(sf: UInt8) {
        self.init(rawValue: sfToRawValue(sf))!
    }
}

public enum MinorKey: Int {
    case A, E, B, Fsharp, Csharp, Gsharp, Dsharp, Asharp, D, G, C, F, Bflat, Eflat, Aflat
    
    init(sf: UInt8) {
        self.init(rawValue: sfToRawValue(sf))!
    }
}
