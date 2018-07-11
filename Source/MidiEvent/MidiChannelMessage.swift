//
//  MidiChannelMessage.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/05.
//  Copyright © 2017年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

public struct MidiChannelMessage: EventProtocol {
    public let timeStamp: MusicTimeStamp
    public let status: UInt8
    public let data1: UInt8
    public let data2: UInt8
    public let reserved: UInt8
}
