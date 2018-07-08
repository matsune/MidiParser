//
//  MidiAUPresetEvent.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/05.
//  Copyright © 2017年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

public struct MidiAUPreset: MidiEventProtocol {
    public var timeStamp: MusicTimeStamp
    public var scope: AudioUnit
    public var element: AudioUnitElement
    public var preset: Unmanaged<CoreFoundation.CFPropertyList>
}
