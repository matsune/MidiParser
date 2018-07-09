//
//  SequenceTrackProperty.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2018/01/14.
//  Copyright © 2018年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

enum SequenceTrackProperty {
    case loopInfo
    case offsetTime
    case muteStatus
    case soloStatus
    case automatedParameters
    case trackLength
    case timeResolution
    
    var inPropertyID: UInt32 {
        switch self {
        case .loopInfo:
            return kSequenceTrackProperty_LoopInfo
        case .offsetTime:
            return kSequenceTrackProperty_OffsetTime
        case .muteStatus:
            return kSequenceTrackProperty_MuteStatus
        case .soloStatus:
            return kSequenceTrackProperty_SoloStatus
        case .automatedParameters:
            return kSequenceTrackProperty_AutomatedParameters
        case .trackLength:
            return kSequenceTrackProperty_TrackLength
        case .timeResolution:
            return kSequenceTrackProperty_TimeResolution
        }
    }
}
