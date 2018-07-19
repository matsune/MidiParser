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
    var format: UInt8 = 1
    
    init() {
        var sequencePtr: MusicSequence?
        check(NewMusicSequence(&sequencePtr), label: "NewMusicSequence")
        guard let sequence = sequencePtr else {
            fatalError("Could not initialize MidiSequence")
        }
        _musicSequence = sequence
    }
    
    deinit {
        check(DisposeMusicSequence(_musicSequence), label: "DisposeMusicSequence", level: .ignore)
    }
    
    func dispose(track: MidiTrack) {
        check(MusicSequenceDisposeTrack(_musicSequence, track._musicTrack),
              label: "MusicSequenceDisposeTrack", level: .ignore)
    }
    
    func load(data: Data) {
        // Check format of SMF in header chunk
        // SMF has 3 types of formats, Format 0 has only 1 truck chunk.
        // Format 1 and 2 have number of using trucks
        // Preffered to use Format 0 -> .smf_ChannelsToTracks
        // Format 1/2 -> .smf_PreserveTracks
        let header = data.withUnsafeBytes {
            UnsafeRawBufferPointer(start: $0, count: Int(sizeof(HeaderChunk.self))).load(as: HeaderChunk.self)
        }
        format = UInt8(header.format.val)
        let inFlags: MusicSequenceLoadFlags = format == 0 ? .smf_ChannelsToTracks : .smf_PreserveTracks
        check(MusicSequenceFileLoadData(_musicSequence, data as CFData, .midiType, inFlags),
              label: "MusicSequenceFileLoadData")
    }
    
    func createData(inFileType: MusicSequenceFileTypeID = .midiType,
                    inFlags: MusicSequenceFileFlags = .eraseFile,
                    inResolution: Int16 = 480) -> Data? {
        var outData: Unmanaged<CFData>?
        check(MusicSequenceFileCreateData(_musicSequence, inFileType, inFlags, inResolution, &outData),
              label: "MusicSequenceFileCreateData")
        if let data = outData {
            return data.takeUnretainedValue() as Data
        }
        return nil
    }
    
    func writeData(to url: URL,
                   inFileType: MusicSequenceFileTypeID = .midiType,
                   inFlags: MusicSequenceFileFlags = .eraseFile,
                   inResolution: Int16 = 480) throws {
        let status = MusicSequenceFileCreate(_musicSequence, url as CFURL, inFileType, inFlags, inResolution)
        if status != noErr {
            throw MidiError.writeURL
        }
    }
    
    var infoDictionary: [MidiInfoKey: AnyObject] {
        guard let dict = MusicSequenceGetInfoDictionary(_musicSequence) as? [String: AnyObject] else {
            return [:]
        }
        return Dictionary(uniqueKeysWithValues: dict.map { (MidiInfoKey(val: $0.key), $0.value) })
    }
    
    var tempoTrack: MusicTrack {
        var tempoTrack: MusicTrack?
        check(MusicSequenceGetTempoTrack(_musicSequence, &tempoTrack),
              label: "MusicSequenceGetTempoTrack", level: .log)
        return tempoTrack!
    }
    
    var trackCount: Int {
        var trackCount: UInt32 = 0
        check(MusicSequenceGetTrackCount(_musicSequence, &trackCount),
              label: "MusicSequenceGetTrackCount", level: .log)
        return Int(trackCount)
    }
    
    func index(ofTrack track: MusicTrack) -> Int {
        var trackIndex: UInt32 = 0
        check(MusicSequenceGetTrackIndex(_musicSequence, track, &trackIndex),
              label: "MusicSequenceGetTrackIndex", level: .log)
        return Int(trackIndex)
    }
    
    func track(at index: Int) -> MusicTrack? {
        var track: MusicTrack?
        check(MusicSequenceGetIndTrack(_musicSequence, UInt32(index), &track),
              label: "MusicSequenceGetIndTrack", level: .log)
        return track
    }
    
    var sequenceType: MusicSequenceType {
        get {
            var type = MusicSequenceType.beats
            check(MusicSequenceGetSequenceType(_musicSequence, &type),
                  label: "MusicSequenceGetSequenceType", level: .log)
            return type
        }
        set {
            check(MusicSequenceSetSequenceType(_musicSequence, newValue),
                  label: "MusicSequenceSetSequenceType", level: .log)
        }
    }
    
    func newTrack() -> MidiNoteTrack {
        var musicTrack: MusicTrack?
        check(MusicSequenceNewTrack(_musicSequence, &musicTrack),
              label: "MusicSequenceNewTrack")
        return MidiNoteTrack(musicTrack: musicTrack!)
    }
}
