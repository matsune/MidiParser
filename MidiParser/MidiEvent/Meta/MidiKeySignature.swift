//
//  MidiKeySignature.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/10.
//  Copyright © 2017年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

public struct MidiKeySignature: MidiEventProtocol {
    public var timeStamp: MusicTimeStamp
    public var keySignature: KeySignature
}
