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
    func reload()
}

extension MidiTrack {
    public func clearEvents(from inStartTime: MusicTimeStamp, to inEndTime: MusicTimeStamp) {
        check(MusicTrackClear(_musicTrack, inStartTime, inEndTime), label: "MusicTrackClear")
        reload()
    }
    
    public func moveEvents(from inStartTime: MusicTimeStamp, to inEndTime: MusicTimeStamp, inMoveTime: MusicTimeStamp) {
        check(MusicTrackMoveEvents(_musicTrack, inStartTime, inEndTime, inMoveTime),
              label: "MusicTrackMoveEvents")
        reload()
    }
    
    public var destAUNode: AUNode {
        get {
            var data = AUNode()
            check(MusicTrackGetDestNode(_musicTrack, &data), label: "MusicTrackGetDestNode",
                  level: .log)
            return data
        }
        set {
            check(MusicTrackSetDestNode(_musicTrack, newValue), label: "MusicTrackSetDestNode")
        }
    }
    
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
    
    func add(patch: MidiPatch) {
        // 0xCn ; n is channel number
        let status = 192 + patch.channel
        var channelMessage = MIDIChannelMessage(status: status,
                                                data1: UInt8(patch.patch.rawValue),
                                                data2: 0,
                                                reserved: 0)
        check(MusicTrackNewMIDIChannelEvent(_musicTrack, 0, &channelMessage),
              label: "MusicTrackNewMIDIChannelEvent")
    }
}
