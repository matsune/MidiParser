//
//  MidiParameterEvent.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/05.
//  Copyright © 2017年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

public struct MidiParameterEvent: MidiEventProtocol {
    public var timeStamp: MusicTimeStamp
    public var parameterID: AudioUnitParameterID
    public var scope: AudioUnitScope
    public var element: AudioUnitElement
    public var value: AudioUnitParameterValue
}
