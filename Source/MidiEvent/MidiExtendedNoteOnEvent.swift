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
    public let timeStamp: MusicTimeStamp
    public let instrumentID: MusicDeviceInstrumentID
    public let groupID: MusicDeviceGroupID
    public let duration: Float32
    public let extendedParams: MusicDeviceNoteParams
}
