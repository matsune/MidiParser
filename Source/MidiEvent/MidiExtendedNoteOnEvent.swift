//
//  MidiExtendedNoteOnEvent.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/05.
//  Copyright © 2017年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

public struct MidiExtendedNoteOnEvent: EventProtocol {
    public var timeStamp: MusicTimeStamp
    public var instrumentID: MusicDeviceInstrumentID
    public var groupID: MusicDeviceGroupID
    public var duration: Float32
    public var extendedParams: MusicDeviceNoteParams
}
