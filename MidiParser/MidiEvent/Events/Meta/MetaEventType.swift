//
//  MetaEventType.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/05.
//  Copyright © 2017年 matsune. All rights reserved.
//

import Foundation

enum MetaEventType: String {
    case trackSequenceNumber = "0"
    case textEvent = "1"
    case copyright = "2"
    case sequenceTrackName = "3"
    case trackInstrumentName = "4"
    case lyric = "5"
    case marker = "6"
    case cuePoint = "7"
    case programName = "8"
    case deviceName = "9"
    case midiChannel = "20"
    case midiPort = "21"
    case endTrack = "2F"
    case setTempo = "51"
    case smpteOffset = "54"
    case timeSignature = "58"
    case keySignature = "59"
    case sequencerSpecific = "7F"
    case unknown
    
    init(_ hex: UInt8) {
        guard let type = MetaEventType(rawValue: String(hex, radix: 16)) else {
            self = .unknown
            return
        }
        self = type
    }
}
