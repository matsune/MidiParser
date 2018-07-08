//
//  MidiNote.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/10.
//  Copyright © 2017年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

public struct MidiNote: MidiEventProtocol {
    public var timeStamp: MusicTimeStamp
    public var duration: Float32
    public var note: UInt8
    public var velocity: UInt8
    public var channel: UInt8
    public var releaseVelocity: UInt8 = 0
    
    func convert() -> MIDINoteMessage {
        return MIDINoteMessage(channel: channel,
                               note: note,
                               velocity: velocity,
                               releaseVelocity: releaseVelocity,
                               duration: duration)
    }
}
