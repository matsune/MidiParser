//
//  MidiSequence.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/04.
//  Copyright © 2017年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

final class MidiSequence {
    private let _musicSequence: MusicSequence
    
    init(data: Data) {
        var sequencePtr: MusicSequence?
        check(NewMusicSequence(&sequencePtr), label: "NewMusicSequence")
        
        guard let sequence = sequencePtr else {
            fatalError("Could not initialize MidiSequence")
        }
        check(MusicSequenceFileLoadData(sequence, data as CFData, MusicSequenceFileTypeID.midiType, []),
              label: "MusicSequenceFileLoadData")
        
        _musicSequence = sequence
    }
    
    deinit {
        check(DisposeMusicSequence(_musicSequence), label: "DisposeMusicSequence", level: .ignore)
    }
    
    func disposeTrack(_ track: MidiTrack) {
        check(MusicSequenceDisposeTrack(_musicSequence, track._musicTrack),
              label: "MusicSequenceDisposeTrack", level: .ignore)
    }
    
    var infoDictionary: CFDictionary {
        return MusicSequenceGetInfoDictionary(_musicSequence)
    }
    
    var tempoTrack: MusicTrack? {
        var tempoTrack: MusicTrack?
        check(MusicSequenceGetTempoTrack(_musicSequence, &tempoTrack),
              label: "MusicSequenceGetTempoTrack", level: .log)
        return tempoTrack
    }
    
    var trackCount: Int {
        var trackCount: UInt32 = 0
        check(MusicSequenceGetTrackCount(_musicSequence, &trackCount),
              label: "MusicSequenceGetTrackCount", level: .log)
        return Int(trackCount)
    }
    
    func getTrackIndex(ofTrack track: MusicTrack) -> Int {
        var trackIndex: UInt32 = 0
        check(MusicSequenceGetTrackIndex(_musicSequence, track, &trackIndex),
              label: "MusicSequenceGetTrackIndex", level: .log)
        return Int(trackIndex)
    }
    
    func getTrack(at index: Int) -> MusicTrack? {
        var track: MusicTrack?
        check(MusicSequenceGetIndTrack(_musicSequence, UInt32(index), &track),
              label: "MusicSequenceGetIndTrack", level: .log)
        return track
    }
}
