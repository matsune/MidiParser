//
//  MidiParameterEvent.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/05.
//  Copyright © 2017年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

public struct MidiParameterEvent: EventProtocol {
    public let timeStamp: MusicTimeStamp
    public let parameterID: AudioUnitParameterID
    public let scope: AudioUnitScope
    public let element: AudioUnitElement
    public let value: AudioUnitParameterValue
}
