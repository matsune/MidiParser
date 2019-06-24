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
    private let musicSequence: MusicSequence
    
    var fileFormat: FileFormat = .type1
    
    var infoDictionary: [MidiInfoKey: AnyObject] {
        guard let dict = MusicSequenceGetInfoDictionary(musicSequence) as? [String: AnyObject] else {
            return [:]
        }
        return Dictionary(uniqueKeysWithValues: dict.map { (MidiInfoKey(val: $0.key), $0.value) })
    }
    
    var tempoTrack: MusicTrack {
        var tempoTrack: MusicTrack?
        check(MusicSequenceGetTempoTrack(musicSequence, &tempoTrack), label: "MusicSequenceGetTempoTrack", level: .log)
        return tempoTrack!
    }
    
    var trackCount: Int {
        var trackCount: UInt32 = 0
        check(MusicSequenceGetTrackCount(musicSequence, &trackCount), label: "MusicSequenceGetTrackCount", level: .log)
        return Int(trackCount)
    }
    
    var sequenceType: MusicSequenceType {
        get {
            var type = MusicSequenceType.beats
            check(MusicSequenceGetSequenceType(musicSequence, &type), label: "MusicSequenceGetSequenceType", level: .log)
            return type
        }
        set {
            check(MusicSequenceSetSequenceType(musicSequence, newValue), label: "MusicSequenceSetSequenceType", level: .log)
        }
    }
    
    init() {
        var sequencePtr: MusicSequence?
        check(NewMusicSequence(&sequencePtr), label: "NewMusicSequence")
        guard let sequence = sequencePtr else {
            fatalError("Could not initialize MidiSequence")
        }
        musicSequence = sequence
    }
    
    deinit {
        check(DisposeMusicSequence(musicSequence), label: "DisposeMusicSequence", level: .ignore)
    }
}

extension MidiSequence {
    
    enum FileFormat: UInt8 {
        case type0
        case type1
        case type2
    }
    
}

extension MidiSequence.FileFormat: CustomStringConvertible {
    
    var description: String {
        switch self {
            case .type0:
                return "A type 0 file contains the entire performance, merged onto a single track"
            case .type1:
                return "A type 1 files may contain any number of tracks, running synchronously"
            case .type2:
                return "A type 2 files may contain any number of tracks, running asynchronously. This type is rarely used"
        }
    }
    
}

extension MidiSequence {
    
    func dispose(track: MidiTrack) {
        check(MusicSequenceDisposeTrack(musicSequence, track.musicTrack), label: "MusicSequenceDisposeTrack", level: .ignore)
    }
    
}

extension MidiSequence {
    
    // Check format of SMF in header chunk
    // SMF has 3 types of formats, Format 0 has only 1 truck chunk.
    // Format 1 and 2 have number of using trucks
    // Preffered to use Format 0 -> .smf_ChannelsToTracks
    // Format 1/2 -> .smf_PreserveTracks
    
    func load(data: Data) {
        func getLoadFlag(inFileFormat format: FileFormat) -> MusicSequenceLoadFlags {
            return format.rawValue == 0 ? .smf_ChannelsToTracks : .smf_PreserveTracks
        }

        func getFileFormat(fromHeader header: HeaderChunk) -> FileFormat {
            return FileFormat(rawValue: UInt8(header.format.val)) ?? .type1
        }
        
        let header = data.withUnsafeBytes {
            UnsafeRawBufferPointer(start: $0, count: Int(sizeof(HeaderChunk.self))).load(as: HeaderChunk.self)
        }
      
        fileFormat = getFileFormat(fromHeader: header)
        let loadFlag = getLoadFlag(inFileFormat: fileFormat)
        
        check(MusicSequenceFileLoadData(musicSequence, data as CFData, .midiType, loadFlag), label: "MusicSequenceFileLoadData")
    }
    
}

//MARK: - Get Data
extension MidiSequence {
    
    func index(ofTrack track: MusicTrack) -> Int {
        var trackIndex: UInt32 = 0
        check(MusicSequenceGetTrackIndex(musicSequence, track, &trackIndex), label: "MusicSequenceGetTrackIndex", level: .log)
        return Int(trackIndex)
    }
    
    func track(at index: Int) -> MusicTrack? {
        var track: MusicTrack?
        check(MusicSequenceGetIndTrack(musicSequence, UInt32(index), &track), label: "MusicSequenceGetIndTrack", level: .log)
        return track
    }
    
}

//MARK: - Generate Data
extension MidiSequence {
    
    func newTrack() -> MidiNoteTrack {
        var musicTrack: MusicTrack?
        check(MusicSequenceNewTrack(musicSequence, &musicTrack), label: "MusicSequenceNewTrack")
        return MidiNoteTrack(musicTrack: musicTrack!)
    }
    
    func createData(inFileType: MusicSequenceFileTypeID = .midiType,
                    inFlags: MusicSequenceFileFlags = .eraseFile,
                    inResolution: Int16 = Int16(TicksPerBeat.regular.value)) -> Data? {
        var outData: Unmanaged<CFData>?
        check(MusicSequenceFileCreateData(musicSequence, inFileType, inFlags, inResolution, &outData),
              label: "MusicSequenceFileCreateData")
        if let data = outData {
            return data.takeUnretainedValue() as Data
        }
        return nil
    }
    
    func writeData(to url: URL,
                   inFileType: MusicSequenceFileTypeID = .midiType,
                   inFlags: MusicSequenceFileFlags = .eraseFile,
                   inResolution: Int16 = Int16(TicksPerBeat.regular.value)) throws {
        let status = MusicSequenceFileCreate(musicSequence, url as CFURL, inFileType, inFlags, inResolution)
        if status != noErr {
            throw MidiError.writeURL
        }
    }
    
}
