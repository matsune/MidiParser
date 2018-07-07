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
    
    public let musicTrack: MusicTrack
    
    init(musicTrack: MusicTrack) {
        self.musicTrack = musicTrack
    }
    
    public var length: MusicTimeStamp {
        var data: MusicTimeStamp = 0
        getProperty(.trackLength, data: &data)
        return data
    }
    
    func getProperty<T>(_ property: SequenceTrackProperty, data: inout T) {
        var length = sizeof(T.self)
        check(MusicTrackGetProperty(musicTrack, property.inPropertyID, &data, &length),
               label: "[MusicTrackGetProperty] \(property)", level: .fatal)
    }
    
    func setProperty<T>(_ property: SequenceTrackProperty, data: inout T) {
        let length = sizeof(T.self)
        check(MusicTrackSetProperty(musicTrack, property.inPropertyID, &data, length),
               label: "[MusicTrackSetProperty] \(property)", level: .fatal)
    }
    
    public func setDest(inNode node: AUNode) {
        check(MusicTrackSetDestNode(musicTrack, node), label: "MusicTrackSetDestNode")
    }
}
