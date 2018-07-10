//
//  MidiTrack.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/04.
//  Copyright © 2017年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

/// Superclass of `MidiTempoTrack` and `MidiNoteTrack`
public class MidiTrack {
    // swiftlint:disable identifier_name
    let _musicTrack: MusicTrack
    let iterator: MidiEventIterator
    
    init(musicTrack: MusicTrack) {
        _musicTrack = musicTrack
        iterator = MidiEventIterator(track: _musicTrack)
    }
    
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
}
