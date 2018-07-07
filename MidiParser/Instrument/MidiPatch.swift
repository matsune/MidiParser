//
//  MidiPatch.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2018/02/03.
//  Copyright © 2018年 matsune. All rights reserved.
//

import Foundation

public struct MidiPatch {
    public let patch: GMPatch
    public let family: PatchFamily
    
    init(program: Int) {
        precondition(0 ..< 128 ~= program, "program must be 0..<128 .")
        patch = GMPatch(rawValue: program)!
        family = PatchFamily(rawValue: patch.rawValue / 8)!
    }
}
