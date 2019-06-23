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
        let note1 = MidiNote(regularTimeStamp: 1.0, duration: 0.5, note: 23, velocity: 10, channel: 2)
        
        XCTAssertEqual(note1.timeStamp, 1.0)
        XCTAssertEqual(note1.ticks.value, 480)
        XCTAssertEqual(note1.duration, 0.5)
        XCTAssertEqual(note1.note, 23)
        XCTAssertEqual(note1.velocity, 10)
        XCTAssertEqual(note1.channel, 2)
        XCTAssertEqual(note1.releaseVelocity, 0)
        
        let note4 = MidiNote(regularTimeStamp: 4.0, duration: 0.5, note: 23, velocity: 10, channel: 2)
        
        XCTAssertEqual(note4.timeStamp, 4.0)
        XCTAssertEqual(note4.ticks.value, 1920)
        XCTAssertEqual(note4.duration, 0.5)
        XCTAssertEqual(note4.note, 23)
        XCTAssertEqual(note4.velocity, 10)
        XCTAssertEqual(note4.channel, 2)
        XCTAssertEqual(note4.releaseVelocity, 0)
    }
    
    func testMidiNote_Convert_ReturnsMidiNoteMessage() {
        let sut = MidiNote(regularTimeStamp: 1.0, duration: 0.5, note: 23, velocity: 10, channel: 2)
        let midiMessage = sut.convert()
        
        XCTAssertEqual(midiMessage.duration, 0.5)
        XCTAssertEqual(midiMessage.note, 23)
        XCTAssertEqual(midiMessage.velocity, 10)
        XCTAssertEqual(midiMessage.channel, 2)
        XCTAssertEqual(midiMessage.releaseVelocity, 0)
    }

}

extension MidiNoteTests {
    
    func testDiffBeatsPerMinute_GetTicks_ReturnsTimes() {
        let sut40 = MidiNote(regularTimeStamp: 4.0, duration: 0.5, note: 23, velocity: 10, channel: 2, beatsPerMinute: BeatsPerMinute(40))
        XCTAssertEqual(sut40.ticks.value, 1_920)
        XCTAssertEqual(sut40.timeStamp, 6.0)
        
        let sut85 = MidiNote(regularTimeStamp: 4.0, duration: 0.5, note: 23, velocity: 10, channel: 2, beatsPerMinute: BeatsPerMinute(85))
        XCTAssertEqual(sut85.ticks.value, 1920)
        XCTAssertEqual(sut85.timeStamp, 2.823)
        
        let sut120 = MidiNote(regularTimeStamp: 4.0, duration: 0.5, note: 23, velocity: 10, channel: 2, beatsPerMinute: BeatsPerMinute(120))
        XCTAssertEqual(sut120.ticks.value, 1920)
        XCTAssertEqual(sut120.timeStamp, 2.0)
    }
    
}

//MARK: - Testing TimeStamp in Ms and Ticks for Diff BPMs
extension MidiNoteTests {
    
    func testRegularBeatsPerMinute_GetTimeStamp_ReturnsConvertedValues() {
        let notes = [
            MidiNote(regularTimeStamp: 4.0, duration: 1.0, note: 23, velocity: 10, channel: 2),
            MidiNote(regularTimeStamp: 5.0, duration: 0.5, note: 23, velocity: 10, channel: 2),
            MidiNote(regularTimeStamp: 5.5, duration: 0.5, note: 23, velocity: 10, channel: 2),
            MidiNote(regularTimeStamp: 6.0, duration: 1.0, note: 23, velocity: 10, channel: 2),
            MidiNote(regularTimeStamp: 8.0, duration: 1.0, note: 23, velocity: 10, channel: 2),
        ]
        
        XCTAssertEqual(notes[0].timeStamp, 4.0)
        XCTAssertEqual(notes[0].ticks.value, 1_920)
        
        XCTAssertEqual(notes[1].timeStamp, 5.0)
        XCTAssertEqual(notes[1].ticks.value, 2_400)
        
        XCTAssertEqual(notes[2].timeStamp, 5.5)
        XCTAssertEqual(notes[2].ticks.value, 2_640)
        
        XCTAssertEqual(notes[3].timeStamp, 6.0)
        XCTAssertEqual(notes[3].ticks.value, 2_880)
        
        XCTAssertEqual(notes[4].timeStamp, 8.0)
        XCTAssertEqual(notes[4].ticks.value, 3_840)
    }
    
    func test45BeatsPerMinute_GetTimeStamp_ReturnsConvertedValues() {
        let notes = [
            MidiNote(regularTimeStamp: 4.0, duration: 1.0, note: 23, velocity: 10, channel: 2, beatsPerMinute: BeatsPerMinute(45)),
            MidiNote(regularTimeStamp: 5.0, duration: 1.0, note: 23, velocity: 10, channel: 2, beatsPerMinute: BeatsPerMinute(45)),
            MidiNote(regularTimeStamp: 6.0, duration: 1.0, note: 23, velocity: 10, channel: 2, beatsPerMinute: BeatsPerMinute(45)),
            MidiNote(regularTimeStamp: 8.0, duration: 1.0, note: 23, velocity: 10, channel: 2, beatsPerMinute: BeatsPerMinute(45)),
            MidiNote(regularTimeStamp: 9.0, duration: 1.0, note: 23, velocity: 10, channel: 2, beatsPerMinute: BeatsPerMinute(45)),
            ]
        
        XCTAssertEqual(notes[0].timeStamp, 5.333)
        XCTAssertEqual(notes[0].ticks.value, 1_920)
        
        XCTAssertEqual(notes[1].timeStamp, 6.666)
        XCTAssertEqual(notes[1].ticks.value, 2_400)
        
        XCTAssertEqual(notes[2].timeStamp, 8.0)
        XCTAssertEqual(notes[2].ticks.value, 2_880)
        
        XCTAssertEqual(notes[3].timeStamp, 10.666)
        XCTAssertEqual(notes[3].ticks.value, 3_840)
        
        XCTAssertEqual(notes[4].timeStamp, 12.0)
        XCTAssertEqual(notes[4].ticks.value, 4_320)
    }
    
    func test85BeatsPerMinute_GetTimeStamp_ReturnsConvertedValues() {
        let notes = [
            MidiNote(regularTimeStamp: 4.0, duration: 0.5, note: 23, velocity: 10, channel: 2, beatsPerMinute: BeatsPerMinute(85)),
            MidiNote(regularTimeStamp: 6.0, duration: 0.25, note: 23, velocity: 10, channel: 2, beatsPerMinute: BeatsPerMinute(85)),
            MidiNote(regularTimeStamp: 6.25, duration: 0.25, note: 23, velocity: 10, channel: 2, beatsPerMinute: BeatsPerMinute(85)),
            MidiNote(regularTimeStamp: 6.5, duration: 0.25, note: 23, velocity: 10, channel: 2, beatsPerMinute: BeatsPerMinute(85)),
            MidiNote(regularTimeStamp: 6.75, duration: 0.25, note: 23, velocity: 10, channel: 2, beatsPerMinute: BeatsPerMinute(85)),
            ]
        
        XCTAssertEqual(notes[0].timeStamp, 2.823)
        XCTAssertEqual(notes[0].ticks.value, 1_920)
        
        XCTAssertEqual(notes[1].timeStamp, 4.235)
        XCTAssertEqual(notes[1].ticks.value, 2_880)
        
        XCTAssertEqual(notes[2].timeStamp, 4.411)
        XCTAssertEqual(notes[2].ticks.value, 3_000)
        
        XCTAssertEqual(notes[3].timeStamp, 4.588)
        XCTAssertEqual(notes[3].ticks.value, 3120)
        
        XCTAssertEqual(notes[4].timeStamp, 4.764)
        XCTAssertEqual(notes[4].ticks.value, 3240)
    }
}
