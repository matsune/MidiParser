//
//  EventInfo.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2018/01/19.
//  Copyright © 2018年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

struct EventInfo {
    let type: MusicEventType
    let timeStamp: MusicTimeStamp
    let data: UnsafeRawPointer?
    let dataSize: UInt32
}
