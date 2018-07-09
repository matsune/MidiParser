//
//  MidiRawData.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/05.
//  Copyright © 2017年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

public struct MidiRawData: MidiEventProtocol {
    public var timeStamp: MusicTimeStamp
    public var length: UInt32
    public var data: UInt8
}
