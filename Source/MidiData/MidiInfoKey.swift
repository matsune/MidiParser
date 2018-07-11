//
//  MidiInfoKey.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2018/07/08.
//  Copyright © 2018 Yuma Matsune. All rights reserved.
//

import AudioToolbox
import Foundation

public enum MidiInfoKey: String {
    case album
    case approximateDurationInSeconds
    case artist
    case channelLayout
    case comments
    case composer
    case copyright
    case encodingApplication
    case genre
    case isrc
    case keySignature
    case lyricist
    case nominalBitRate
    case recordedDate
    case sourceBitDepth
    case sourceEncoder
    case subTitle
    case tempo
    case timeSignature
    case title
    case trackNumber
    case year
    case unknown
    
    // swiftlint:disable function_body_length cyclomatic_complexity
    init(val: String) {
        switch val {
        case kAFInfoDictionary_Album:
            self = .album
        case kAFInfoDictionary_ApproximateDurationInSeconds:
            self = .approximateDurationInSeconds
        case kAFInfoDictionary_Artist:
            self = .artist
        case kAFInfoDictionary_ChannelLayout:
            self = .channelLayout
        case kAFInfoDictionary_Comments:
            self = .comments
        case kAFInfoDictionary_Composer:
            self = .composer
        case kAFInfoDictionary_Copyright:
            self = .copyright
        case kAFInfoDictionary_EncodingApplication:
            self = .encodingApplication
        case kAFInfoDictionary_Genre:
            self = .genre
        case kAFInfoDictionary_ISRC:
            self = .isrc
        case kAFInfoDictionary_KeySignature:
            self = .keySignature
        case kAFInfoDictionary_Lyricist:
            self = .lyricist
        case kAFInfoDictionary_NominalBitRate:
            self = .nominalBitRate
        case kAFInfoDictionary_RecordedDate:
            self = .recordedDate
        case kAFInfoDictionary_SourceBitDepth:
            self = .sourceBitDepth
        case kAFInfoDictionary_SourceEncoder:
            self = .sourceEncoder
        case kAFInfoDictionary_SubTitle:
            self = .subTitle
        case kAFInfoDictionary_Tempo:
            self = .tempo
        case kAFInfoDictionary_TimeSignature:
            self = .timeSignature
        case kAFInfoDictionary_Title:
            self = .title
        case kAFInfoDictionary_TrackNumber:
            self = .trackNumber
        case kAFInfoDictionary_Year:
            self = .year
        default:
            self = .unknown
        }
    }
}
