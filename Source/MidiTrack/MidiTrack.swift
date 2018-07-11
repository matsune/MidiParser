//
//  MidiTrack.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/04.
//  Copyright © 2017年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

protocol MidiTrack {
    // swiftlint:disable identifier_name
    var _musicTrack: MusicTrack { get }
    var iterator: EventIterator { get }
    init(musicTrack: MusicTrack)
}

extension MidiTrack {
    func bindEventData<T>(info: EventInfo) -> T? {
        guard let type = MidiEventType(info.type) else {
            return nil
        }
        switch type {
        case .extendedNote where T.self == ExtendedNoteOnEvent.self,
             .extendedTempo where T.self == ExtendedTempoEvent.self,
             .user where T.self == MusicEventUserData.self,
             .meta where T.self == MIDIMetaEvent.self,
             .midiNoteMessage where T.self == MIDINoteMessage.self,
             .midiChannelMessage where T.self == MIDIChannelMessage.self,
             .midiRawData where T.self == MIDIRawData.self,
             .parameter where T.self == ParameterEvent.self,
             .auPreset where T.self == AUPresetEvent.self:
            return info.data?.assumingMemoryBound(to: T.self).pointee
        default:
            return nil
        }
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
    
    func add(metaEvent: MetaEventProtocol) {
        var e = MIDIMetaEvent()
        e.metaEventType = UInt8(metaEvent.metaType.rawValue)
        e.dataLength = UInt32(metaEvent.bytes.count)
        write(bytes: metaEvent.bytes, to: &e.data)
        check(MusicTrackNewMetaEvent(_musicTrack, metaEvent.timeStamp, &e),
              label: "MusicTrackNewMetaEvent")
    }
    
    func add(extendedTempo: MidiExtendedTempo) {
        check(MusicTrackNewExtendedTempoEvent(_musicTrack, extendedTempo.timeStamp, extendedTempo.bpm),
              label: "MusicTrackNewExtendedTempoEvent")
    }
}
