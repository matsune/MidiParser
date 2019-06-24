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
    public private(set) var tempoTrack: MidiTempoTrack
    public private(set) var noteTracks: [MidiNoteTrack]
    
    public var format: UInt8 {
        return sequence.fileFormat.rawValue
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
        return sequence.infoDictionary
    }
    
    public lazy var beatsPerMinute: BeatsPerMinute = {
        if tempoTrack.extendedTempos.isEmpty {
            return BeatsPerMinute.regular
        }
        
        return BeatsPerMinute(UInt(tempoTrack.extendedTempos[0].bpm))
    }()
    
    public lazy var ticksPerBeat: TicksPerBeat = TicksPerBeat(UInt(tempoTrack.timeResolution))
    
    
    public init() {
        sequence = MidiSequence()
        tempoTrack = MidiTempoTrack(musicTrack: sequence.tempoTrack)
        noteTracks = []
    }
    
    deinit {
        disposeTracks()
    }
    
}

//MARK: -  Convert MidiData to Sequence
public extension MidiData {
    
    func load(data: Data) {
        disposeTracks()
        sequence.load(data: data)
        retainTracks()
    }
    
    func createData(inFileType: MusicSequenceFileTypeID = .midiType,
                           inFlags: MusicSequenceFileFlags = .eraseFile,
                           inResolution: Int16 = Int16(TicksPerBeat.regular.value)) -> Data? {
        return sequence.createData(inFileType: inFileType, inFlags: inFlags, inResolution: inResolution)
    }
}

//MARK: - Get Tracks From Sequence
private extension MidiData {
    
    func retainTracks() {
        tempoTrack = MidiTempoTrack(musicTrack: sequence.tempoTrack)
        var tracks: [MidiNoteTrack] = []
        for i in 0 ..< sequence.trackCount {
            if let musicTrack = sequence.track(at: i) {
                let track = MidiNoteTrack(musicTrack: musicTrack, beatsPerMinute: beatsPerMinute, ticksPerBeat: ticksPerBeat)
                tracks.append(track)
            }
        }
        noteTracks = tracks
    }
    
}


//MARK: - Dispose Tracks
public extension MidiData {
    
    func disposeTracks() {
        sequence.dispose(track: tempoTrack)
        noteTracks.forEach { sequence.dispose(track: $0) }
        noteTracks.removeAll()
    }
    
}

//MARK: - Mutating
public extension MidiData {

    @discardableResult
    func addTrack() -> MidiNoteTrack {
        let track = sequence.newTrack()
        noteTracks.append(track)
        return track
    }
    
    func removeTrack(at index: Int) {
        sequence.dispose(track: noteTracks[index])
        noteTracks.remove(at: index)
    }
    
    func remove(track: MidiNoteTrack) {
        if let idx = noteTracks.firstIndex(of: track) {
            removeTrack(at: idx)
        }
    }
 
    func writeData(to url: URL, inFileType: MusicSequenceFileTypeID = .midiType, inFlags: MusicSequenceFileFlags = .eraseFile, inResolution: Int16 = Int16(TicksPerBeat.regular.value)) throws {
        try sequence.writeData(to: url, inFileType: inFileType, inFlags: inFlags, inResolution: inResolution)
    }
    
}
