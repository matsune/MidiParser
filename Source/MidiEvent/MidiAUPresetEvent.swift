//
//  MidiAUPresetEvent.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/05.
//  Copyright © 2017年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

public struct MidiAUPreset: EventProtocol {
    public let timeStamp: MusicTimeStamp
    public let scope: AudioUnit
    public let element: AudioUnitElement
    public let preset: Unmanaged<CoreFoundation.CFPropertyList>
}
