//
//  HeaderChunk.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2018/07/10.
//  Copyright © 2018 Yuma Matsune. All rights reserved.
//

import Foundation

struct HeaderChunk {
    var ident: DWord // MThd
    var length: DWord // 00 00 00 06
    var format: Word // 00 0[0|1|2]
    var n: Word
    var division: Word
}
