//
//  MidiExtendedTempo.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/05.
//  Copyright © 2017年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

public struct MidiExtendedTempo: MidiEventProtocol {
    public var timeStamp: MusicTimeStamp
    public var bpm: Float64
}
