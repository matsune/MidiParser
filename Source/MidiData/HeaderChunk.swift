//
//  HeaderChunk.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2018/07/10.
//  Copyright © 2018 Yuma Matsune. All rights reserved.
//

import Foundation

struct HeaderChunk {
    var ident: (UInt8, UInt8, UInt8, UInt8)     // MThd
    var length: (UInt8, UInt8, UInt8, UInt8)    // 00 00 00 06
    var format: (UInt8, UInt8)                  // 00 0[0|1|2]
    var n: (UInt8, UInt8)
    var division: (UInt8, UInt8)
}
