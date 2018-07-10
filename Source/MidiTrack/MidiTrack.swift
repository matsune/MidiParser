//
//  MidiTrack.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/04.
//  Copyright © 2017年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

protocol MidiTrack {
    // swiftlint:disable identifier_name
    var _musicTrack: MusicTrack { get }
    var iterator: MidiEventIterator { get }
    init(musicTrack: MusicTrack)
}

extension MidiTrack {
    func getProperty<T>(_ property: SequenceTrackProperty, data: inout T) {
        var length = sizeof(T.self)
        check(MusicTrackGetProperty(_musicTrack, property.inPropertyID, &data, &length),
              label: "[MusicTrackGetProperty] \(property)", level: .fatal)
    }
    
    func setProperty<T>(_ property: SequenceTrackProperty, data: inout T) {
        let length = sizeof(T.self)
        check(MusicTrackSetProperty(_musicTrack, property.inPropertyID, &data, length),
              label: "[MusicTrackSetProperty] \(property)", level: .fatal)
    }
    
    func add(metaEvent: MetaEventProtocol) {
        var e = MIDIMetaEvent()
        e.metaEventType = UInt8(metaEvent.metaType.rawValue)
        e.dataLength = UInt32(metaEvent.bytes.count)
        write(bytes: metaEvent.bytes, to: &e.data)
        check(MusicTrackNewMetaEvent(_musicTrack, metaEvent.timeStamp, &e),
              label: "MusicTrackNewMetaEvent")
    }
    
    func add(extendedTempo: MidiExtendedTempo) {
        check(MusicTrackNewExtendedTempoEvent(_musicTrack, extendedTempo.timeStamp, extendedTempo.bpm),
              label: "MusicTrackNewExtendedTempoEvent")
    }
}
