//
//  MidiSequence.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/04.
//  Copyright © 2017年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

public final class MidiSequence {
    private let musicSequence: MusicSequence
    
    init(data: Data) {
        var sequencePtr: MusicSequence?
        check(NewMusicSequence(&sequencePtr), label: "NewMusicSequence")
        
        guard let sequence = sequencePtr else {
            fatalError("MidiSequence error")
        }
        check(MusicSequenceFileLoadData(sequence, data as CFData, MusicSequenceFileTypeID.midiType, []),
              label: "MusicSequenceFileLoadData")
        
        musicSequence = sequence
    }
    
    deinit {
        check(DisposeMusicSequence(musicSequence), label: "DisposeMusicSequence", level: .ignore)
    }
    
    func disposeTrack(_ track: MidiTrack) {
        check(MusicSequenceDisposeTrack(musicSequence, track.musicTrack),
              label: "MusicSequenceDisposeTrack", level: .ignore)
    }
    
    public var infoDictionary: CFDictionary {
        return MusicSequenceGetInfoDictionary(musicSequence)
    }
    
    public var tempoTrack: MusicTrack? {
        var tempoTrack: MusicTrack?
        check(MusicSequenceGetTempoTrack(musicSequence, &tempoTrack),
              label: "MusicSequenceGetTempoTrack", level: .log)
        return tempoTrack
    }
    
    public var trackCount: Int {
        var trackCount: UInt32 = 0
        check(MusicSequenceGetTrackCount(musicSequence, &trackCount),
              label: "MusicSequenceGetTrackCount", level: .log)
        return Int(trackCount)
    }
    
    public func getTrackIndex(ofTrack track: MusicTrack) -> Int {
        var trackIndex: UInt32 = 0
        check(MusicSequenceGetTrackIndex(musicSequence, track, &trackIndex),
              label: "MusicSequenceGetTrackIndex", level: .log)
        return Int(trackIndex)
    }
    
    public func getTrack(at index: Int) -> MusicTrack? {
        var track: MusicTrack?
        check(MusicSequenceGetIndTrack(musicSequence, UInt32(index), &track),
              label: "MusicSequenceGetIndTrack", level: .log)
        return track
    }
}
