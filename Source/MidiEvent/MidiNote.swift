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
    
    private let regularTempoTimeStamp: MusicTimeStamp
    
    public let ticks: Ticks
    public let timeStamp: MusicTimeStamp
    public let duration: Float32
    public let note: UInt8
    public let velocity: UInt8
    public let channel: UInt8
    public let releaseVelocity: UInt8

    public init(regularTimeStamp: MusicTimeStamp, duration: Float32, note: UInt8, velocity: UInt8, channel: UInt8, releaseVelocity: UInt8 = 0, beatsPerMinute: BeatsPerMinute = BeatsPerMinute.regular, ticksPerBeat: TicksPerBeat = TicksPerBeat.regular) {
        self.regularTempoTimeStamp = regularTimeStamp
        self.ticks = Milliseconds(regularTimeStamp).toTicks(andTicksPerBeat: ticksPerBeat)
        self.timeStamp = ticks.toMs(forBeatsPerMinute: beatsPerMinute, andTicksPerBeat: ticksPerBeat).seconds
        self.duration = duration
        self.note = note
        self.velocity = velocity
        self.channel = channel
        self.releaseVelocity = releaseVelocity
    }
    
}

extension MidiNote {

    func convert() -> MIDINoteMessage {
        return MIDINoteMessage(channel: channel, note: note, velocity: velocity, releaseVelocity: releaseVelocity, duration: duration)
    }

}
