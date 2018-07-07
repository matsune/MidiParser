//
//  MidiEventType.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/04.
//  Copyright © 2017年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

public enum MidiEventType: CustomDebugStringConvertible {
    case null
    case extendedNote
    case extendedTempo
    case user
    case meta
    case midiNoteMessage
    case midiChannelMessage
    case midiRawData
    case parameter
    case auPreset
    
    // swiftlint:disable cyclomatic_complexity
    init?(_ kMusicEventType: UInt32) {
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
            self = .midiNoteMessage
        case kMusicEventType_MIDIChannelMessage:
            self = .midiChannelMessage
        case kMusicEventType_MIDIRawData:
            self = .midiRawData
        case kMusicEventType_Parameter:
            self = .parameter
        case kMusicEventType_AUPreset:
            self = .auPreset
        default:
            return nil
        }
    }
    
    // - MARK: CustomDebugStringConvertible
    public var debugDescription: String {
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
        case .midiNoteMessage:
            return "MidiEventType.midiNoteMessage"
        case .midiChannelMessage:
            return "MidiEventType.midiChannelMessage"
        case .midiRawData:
            return "MidiEventType.midiRawData"
        case .parameter:
            return "MidiEventType.parameter"
        case .auPreset:
            return "MidiEventType.auPreset"
        }
    }
}
