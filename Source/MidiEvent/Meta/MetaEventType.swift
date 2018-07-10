//
//  MetaEventType.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/05.
//  Copyright © 2017年 matsune. All rights reserved.
//

import Foundation

/*
 -----------------------
 Type    Event
 -----------------------
 0x00    Sequence number
 0x01    Text event
 0x02    Copyright notice
 0x03    Sequence or track name
 0x04    Instrument name
 0x05    Lyric text
 0x06    Marker text
 0x07    Cue point
 0x20    MIDI channel prefix assignment
 0x2F    End of track
 0x51    Tempo setting
 0x54    SMPTE offset
 0x58    Time signature
 0x59    Key signature
 0x7F    Sequencer specific event
 -----------------------
 */
enum MetaEventType: Int {
    case trackSequenceNumber = 0
    case textEvent = 1
    case copyright = 2
    case sequenceTrackName = 3
    case trackInstrumentName = 4
    case lyric = 5
    case marker = 6
    case cuePoint = 7
    case programName = 8
    case deviceName = 9
    case midiChannel = 32
    case midiPort = 33
    case endTrack = 47
    case setTempo = 81
    case smpteOffset = 84
    case timeSignature = 88
    case keySignature = 89
    case sequencerSpecific = 127
    
    init?(byte: Byte) {
        self.init(rawValue: Int(byte))
    }
}
