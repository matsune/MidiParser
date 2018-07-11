//
//  MidiPatch.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2018/02/03.
//  Copyright © 2018年 matsune. All rights reserved.
//

import Foundation

/// Standard MIDI Patch Assignments
/// [Microsoft documents](https://docs.microsoft.com/en-us/windows/desktop/multimedia/standard-midi-patch-assignments)
public struct MidiPatch {
    public let patch: GMPatch
    public let family: PatchFamily
    
    public init?(program: Int) {
        guard 0 ..< 128 ~= program else {
            return nil
        }
        patch = GMPatch(rawValue: program)!
        family = PatchFamily(rawValue: patch.rawValue / 8)!
    }
}
