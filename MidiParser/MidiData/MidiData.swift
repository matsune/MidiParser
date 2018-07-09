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
    
    init() {
        sequence = MidiSequence()
        tempoTrack = MidiTempoTrack(musicTrack: sequence.tempoTrack)
        var tracks: [MidiNoteTrack] = []
        for i in 0 ..< sequence.trackCount {
            if let track = sequence.track(at: i) {
                tracks.append(MidiNoteTrack(musicTrack: track))
            }
        }
        noteTracks = tracks
    }
    
    deinit {
        disposeTracks()
    }
    
    public func load(data: Data, inFileTypeHint: MusicSequenceFileTypeID = .midiType, inFlags: MusicSequenceLoadFlags = .smf_ChannelsToTracks) {
        disposeTracks()
        sequence.load(data: data, inFileTypeHint: inFileTypeHint, inFlags: inFlags)
        retainTracks()
    }
    
    public func load(url: URL, inFileTypeHint: MusicSequenceFileTypeID = .midiType, inFlags: MusicSequenceLoadFlags = .smf_ChannelsToTracks) {
        disposeTracks()
        sequence.load(url: url, inFileTypeHint: inFileTypeHint, inFlags: inFlags)
        retainTracks()
    }
    
    private func disposeTracks() {
        sequence.dispose(track: tempoTrack)
        noteTracks.forEach { sequence.dispose(track: $0) }
        noteTracks.removeAll()
    }
    
    private func retainTracks() {
        tempoTrack = MidiTempoTrack(musicTrack: sequence.tempoTrack)
        var tracks: [MidiNoteTrack] = []
        for i in 0 ..< sequence.trackCount {
            if let track = sequence.track(at: i) {
                tracks.append(MidiNoteTrack(musicTrack: track))
            }
        }
        noteTracks = tracks
    }
    
    public func writeData(to url: URL, inFileType: MusicSequenceFileTypeID = .midiType, inFlags: MusicSequenceFileFlags = .eraseFile, inResolution: Int16 = 480) throws {
        try sequence.writeData(to: url, inFileType: inFileType, inFlags: inFlags, inResolution: inResolution)
    }
    
    public func createData(inFileType: MusicSequenceFileTypeID = .midiType, inFlags: MusicSequenceFileFlags = .eraseFile, inResolution: Int16 = 480) -> Data? {
        return sequence.createData(inFileType: inFileType, inFlags: inFlags, inResolution: inResolution)
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
    
    public func addTrack() {
        let track = sequence.newTrack()
        noteTracks.append(track)
    }
}
