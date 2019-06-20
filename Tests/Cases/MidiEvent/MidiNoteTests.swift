//
//  MidiNoteTests.swift
//  MidiParser iOSTests
//
//  Created by Vladimir Vybornov on 6/20/19.
//  Copyright © 2019 Yuma Matsune. All rights reserved.
//

import XCTest
@testable import MidiParser

final class MidiNoteTests: XCTestCase {

    func testInit_ReturnsMidiNoteInstance() {
        let sut = MidiNote(timeStamp: 1.0, duration: 0.5, note: 23, velocity: 10, channel: 2)
        
        XCTAssertEqual(sut.timeStamp, 1.0)
        XCTAssertEqual(sut.duration, 0.5)
        XCTAssertEqual(sut.note, 23)
        XCTAssertEqual(sut.velocity, 10)
        XCTAssertEqual(sut.channel, 2)
        XCTAssertEqual(sut.releaseVelocity, 0)
    }
    
    func testMidiNote_Convert_ReturnsMidiNoteMessage() {
        let sut = MidiNote(timeStamp: 1.0, duration: 0.5, note: 23, velocity: 10, channel: 2)
        let midiMessage = sut.convert()
        
        XCTAssertEqual(midiMessage.duration, 0.5)
        XCTAssertEqual(midiMessage.note, 23)
        XCTAssertEqual(midiMessage.velocity, 10)
        XCTAssertEqual(midiMessage.channel, 2)
        XCTAssertEqual(midiMessage.releaseVelocity, 0)
    }
    
    func testDiffBeatsPerMinuteEqual_GetTicks_ReturnsTimeInTicks() {
        let sut = MidiNote(timeStamp: 1.0, duration: 0.5, note: 23, velocity: 10, channel: 2)
        
        XCTAssertEqual(sut.timeStampInTicks(forBeatsPerMinute: 40, andTicksPerBeat: 480), 320)
        XCTAssertEqual(sut.durationInTicks(forBeatsPerMinute: 40, andTicksPerBeat: 480), 160)
        
        XCTAssertEqual(sut.timeStampInTicks(forBeatsPerMinute: 60, andTicksPerBeat: 480), 480)
        XCTAssertEqual(sut.durationInTicks(forBeatsPerMinute: 60, andTicksPerBeat: 480), 240)
        
        XCTAssertEqual(sut.timeStampInTicks(forBeatsPerMinute: 80, andTicksPerBeat: 480), 640)
        XCTAssertEqual(sut.durationInTicks(forBeatsPerMinute: 80, andTicksPerBeat: 480), 320)
        
        XCTAssertEqual(sut.timeStampInTicks(forBeatsPerMinute: 100, andTicksPerBeat: 480), 800)
        XCTAssertEqual(sut.durationInTicks(forBeatsPerMinute: 100, andTicksPerBeat: 480), 400)
    }
    
}
