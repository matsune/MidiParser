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
    
    public var numberOfTracks: Int {
        return noteTracks.count
    }
    
    public var length: MusicTimeStamp {
        return noteTracks.map { $0.length }.max() ?? 0
    }
    
    public var infoDictionary: [String: AnyObject]? {
        return sequence.infoDictionary as? [String: AnyObject]
    }
}
