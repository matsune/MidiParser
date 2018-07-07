//
//  MidiNoteEvent.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/10.
//  Copyright © 2017年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

public final class MidiNoteEvent: MidiEvent {
    public var duration: MusicTimeStamp
    public var note: Int
    public var velocity: Int
    public var channel: Int
    public var releaseVelocity: Int
    
    init(eventInfo: MidiEventInfo, midiNoteMessage: MIDINoteMessage) {
        duration = MusicTimeStamp(max(0.5, midiNoteMessage.duration))
        note = Int(midiNoteMessage.note)
        velocity = Int(midiNoteMessage.velocity)
        channel = Int(midiNoteMessage.channel)
        releaseVelocity = Int(midiNoteMessage.releaseVelocity)
        super.init(eventInfo: eventInfo)
    }
    
    // - MARK: CustomDebugStringConvertible
    public override var debugDescription: String {
        return "MidiNote(timeStamp: \(timeStamp), duration: \(duration), note: \(note), velocity: \(velocity), channel: \(channel), releaseVelocity: \(releaseVelocity))"
    }
}
