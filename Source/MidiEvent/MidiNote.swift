//
//  MidiNote.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/10.
//  Copyright © 2017年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

public struct MidiNote: EventProtocol {
    public let timeStamp: MusicTimeStamp
    public let duration: Float32
    public let note: UInt8
    public let velocity: UInt8
    public let channel: UInt8
    public let releaseVelocity: UInt8
    
    public init(timeStamp: MusicTimeStamp,
                duration: Float32,
                note: UInt8,
                velocity: UInt8,
                channel: UInt8,
                releaseVelocity: UInt8 = 0) {
        self.timeStamp = timeStamp
        self.duration = duration
        self.note = note
        self.velocity = velocity
        self.channel = channel
        self.releaseVelocity = releaseVelocity
    }
    
    func convert() -> MIDINoteMessage {
        return MIDINoteMessage(channel: channel,
                               note: note,
                               velocity: velocity,
                               releaseVelocity: releaseVelocity,
                               duration: duration)
    }
}
