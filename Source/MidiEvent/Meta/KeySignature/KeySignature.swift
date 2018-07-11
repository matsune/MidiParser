//
//  KeySignature.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/08.
//  Copyright © 2017年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

//  sf: 0, 1, 2, 3, 4, 5, 6, 7, 255, 254, 253, 252, 251, 250, 249

public enum KeySignature: Equatable {
    case major(MajorKey)
    case minor(MinorKey)
    
    var bytes: Bytes {
        switch self {
        case let .major(key):
            return [key.rawValue, 0]
        case let .minor(key):
            return [key.rawValue, 1]
        }
    }
}

public enum MajorKey: UInt8 {
    case C = 0
    case G = 1
    case D = 2
    case A = 3
    case E = 4
    case B = 5
    case Fsharp = 6
    case Csharp = 7
    case F = 255
    case Bflat = 254
    case Eflat = 253
    case Aflat = 252
    case Dflat = 251
    case Gflat = 250
    case Cflat = 249
}

public enum MinorKey: UInt8 {
    case A = 0
    case E = 1
    case B = 2
    case Fsharp = 3
    case Csharp = 4
    case Gsharp = 5
    case Dsharp = 6
    case Asharp = 7
    case D = 255
    case G = 254
    case C = 253
    case F = 252
    case Bflat = 251
    case Eflat = 250
    case Aflat = 249
}
