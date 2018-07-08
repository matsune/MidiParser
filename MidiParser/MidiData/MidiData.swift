//
//  MidiData.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/04.
//  Copyright © 2017年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

public final class MidiData {
    private let sequence: MidiSequence
    public let tempoTrack: MidiTempoTrack?
    public let noteTracks: [MidiNoteTrack]
    
    public init(data: Data) {
        sequence = MidiSequence(data: data)
        
        if let tempoTrack = sequence.tempoTrack {
            self.tempoTrack = MidiTempoTrack(musicTrack: tempoTrack)
        } else {
            tempoTrack = nil
        }
        
        var tracks: [MidiNoteTrack] = []
        for i in 0 ..< sequence.trackCount {
            if let track = sequence.getTrack(at: i) {
                let track = MidiNoteTrack(musicTrack: track)
                if !track.notes.isEmpty {
                    tracks.append(track)
                }
            }
        }
        noteTracks = tracks
    }
    
    deinit {
        if let tempoTrack = tempoTrack {
            sequence.disposeTrack(tempoTrack)
        }
        noteTracks.forEach { sequence.disposeTrack($0) }
    }
    
    public var sequenceType: MusicSequenceType {
        get {
            return sequence.sequenceType
        }
        set {
            sequence.sequenceType = newValue
        }
    }
    
    public var infoDictionary: [MidiInfoKey: AnyObject] {
        guard let dict = sequence.infoDictionary as? [String: AnyObject] else {
            return [:]
        }
        return Dictionary(uniqueKeysWithValues: dict.map { (MidiInfoKey(val: $0.key)!, $0.value) })
    }
}
