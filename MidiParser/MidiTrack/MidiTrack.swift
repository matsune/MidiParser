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
    
    init(musicTrack: MusicTrack) {
        _musicTrack = musicTrack
    }
    
    public var length: MusicTimeStamp {
        var data: MusicTimeStamp = 0
        getProperty(.trackLength, data: &data)
        return data
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
}
