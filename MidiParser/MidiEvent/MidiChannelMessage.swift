//
//  MidiChannelMessage.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/05.
//  Copyright © 2017年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

public struct MidiChannelMessage: MidiEventProtocol {
    public var timeStamp: MusicTimeStamp
    public var status: UInt8
    public var data1: UInt8
    public var data2: UInt8
    public var reserved: UInt8
}
