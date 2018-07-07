//
//  KeySignature.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/08.
//  Copyright © 2017年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

public enum KeySignature {
    // swiftlint:disable identifier_name cyclomatic_complexity
    case C, D, G, A, E, B, Fsharp, Csharp, F, Bflat, Eflat, Aflat, Dflat, Gflat, Cflat
    
    init(_ sf: Int) {
        switch sf {
        case 0:
            self = .C
        case 1:
            self = .G
        case 2:
            self = .D
        case 3:
            self = .A
        case 4:
            self = .E
        case 5:
            self = .B
        case 6:
            self = .Fsharp
        case 7:
            self = .Csharp
        case 255:
            self = .F
        case 254:
            self = .Bflat
        case 253:
            self = .Eflat
        case 252:
            self = .Aflat
        case 251:
            self = .Dflat
        case 250:
            self = .Gflat
        case 249:
            self = .Cflat
        default:
            self = .C
        }
    }
}
