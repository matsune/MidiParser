//
//  MidiEventType.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/04.
//  Copyright © 2017年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

public enum MidiEventType: CustomDebugStringConvertible, CaseIterable {
    case null
    case extendedNote
    case extendedTempo
    case user
    case meta
    case noteMessage
    case channelMessage
    case rawData
    case parameter
    case auPreset
    
    // swiftlint:disable cyclomatic_complexity
    init?(_ kMusicEventType: MusicEventType) {
        switch kMusicEventType {
        case kMusicEventType_NULL:
            self = .null
        case kMusicEventType_ExtendedNote:
            self = .extendedNote
        case kMusicEventType_ExtendedTempo:
            self = .extendedTempo
        case kMusicEventType_User:
            self = .user
        case kMusicEventType_Meta:
            self = .meta
        case kMusicEventType_MIDINoteMessage:
            self = .noteMessage
        case kMusicEventType_MIDIChannelMessage:
            self = .channelMessage
        case kMusicEventType_MIDIRawData:
            self = .rawData
        case kMusicEventType_Parameter:
            self = .parameter
        case kMusicEventType_AUPreset:
            self = .auPreset
        default:
            return nil
        }
    }
}

public extension MidiEventType {
    
    var debugDescription: String {
        switch self {
        case .null:
            return "MidiEventType.null"
        case .extendedNote:
            return "MidiEventType.extendedNote"
        case .extendedTempo:
            return "MidiEventType.extendedTempo"
        case .user:
            return "MidiEventType.user"
        case .meta:
            return "MidiEventType.meta"
        case .noteMessage:
            return "MidiEventType.midiNoteMessage"
        case .channelMessage:
            return "MidiEventType.midiChannelMessage"
        case .rawData:
            return "MidiEventType.midiRawData"
        case .parameter:
            return "MidiEventType.parameter"
        case .auPreset:
            return "MidiEventType.auPreset"
        }
    }
}
