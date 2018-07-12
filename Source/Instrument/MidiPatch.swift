//
//  MidiPatch.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2018/02/03.
//  Copyright © 2018年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

/// Standard MIDI Patch Assignments
/// [Microsoft documents](https://docs.microsoft.com/en-us/windows/desktop/multimedia/standard-midi-patch-assignments)
public struct MidiPatch {
    public let channel: UInt8
    public let patch: GMPatch
    public let family: PatchFamily
    
    public init(channel: UInt8, patch: GMPatch) {
        self.channel = channel
        self.patch = patch
        family = PatchFamily(rawValue: patch.rawValue / 8)!
    }
}
