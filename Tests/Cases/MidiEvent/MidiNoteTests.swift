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
        let note1 = MidiNote(regularTimeStamp: 1.0, regularDuration: 0.5, note: 23, velocity: 10, channel: 2)
        
        XCTAssertEqual(note1.timeStamp.inSeconds, 1.0)
        XCTAssertEqual(note1.timeStamp.inTicks.value, 480)
        XCTAssertEqual(note1.duration.inSeconds, 0.5)
        XCTAssertEqual(note1.note, 23)
        XCTAssertEqual(note1.velocity, 10)
        XCTAssertEqual(note1.channel, 2)
        XCTAssertEqual(note1.releaseVelocity, 0)
        
        let note4 = MidiNote(regularTimeStamp: 4.0, regularDuration: 0.5, note: 23, velocity: 10, channel: 2)
        
        XCTAssertEqual(note4.timeStamp.inSeconds, 4.0)
        XCTAssertEqual(note4.timeStamp.inTicks.value, 1920)
        XCTAssertEqual(note4.duration.inSeconds, 0.5)
        XCTAssertEqual(note4.note, 23)
        XCTAssertEqual(note4.velocity, 10)
        XCTAssertEqual(note4.channel, 2)
        XCTAssertEqual(note4.releaseVelocity, 0)
    }
    
    func testMidiNote_Convert_ReturnsMidiNoteMessage() {
        let sut = MidiNote(regularTimeStamp: 1.0, regularDuration: 0.5, note: 23, velocity: 10, channel: 2)
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
        let sut40 = MidiNote(regularTimeStamp: 4.0, regularDuration: 0.5, note: 23, velocity: 10, channel: 2, beatsPerMinute: BeatsPerMinute(40))
        XCTAssertEqual(sut40.timeStamp.inTicks.value, 1_920)
        XCTAssertEqual(sut40.timeStamp.inSeconds, 6.0)
        
        let sut85 = MidiNote(regularTimeStamp: 4.0, regularDuration: 0.5, note: 23, velocity: 10, channel: 2, beatsPerMinute: BeatsPerMinute(85))
        XCTAssertEqual(sut85.timeStamp.inTicks.value, 1920)
        XCTAssertEqual(sut85.timeStamp.inSeconds, 2.823)
        
        let sut120 = MidiNote(regularTimeStamp: 4.0, regularDuration: 0.5, note: 23, velocity: 10, channel: 2, beatsPerMinute: BeatsPerMinute(120))
        XCTAssertEqual(sut120.timeStamp.inTicks.value, 1920)
        XCTAssertEqual(sut120.timeStamp.inSeconds, 2.0)
    }
    
}

//MARK: - Testing TimeStamp in Ms and Ticks for Diff BPMs
extension MidiNoteTests {
    
    func testRegularBeatsPerMinute_GetTimeStamp_ReturnsConvertedValues() {
        let notes = [
            MidiNote(regularTimeStamp: 4.0, regularDuration: 1.0, note: 23, velocity: 10, channel: 2),
            MidiNote(regularTimeStamp: 5.0, regularDuration: 0.5, note: 23, velocity: 10, channel: 2),
            MidiNote(regularTimeStamp: 5.5, regularDuration: 0.5, note: 23, velocity: 10, channel: 2),
            MidiNote(regularTimeStamp: 6.0, regularDuration: 1.0, note: 23, velocity: 10, channel: 2),
            MidiNote(regularTimeStamp: 8.0, regularDuration: 1.0, note: 23, velocity: 10, channel: 2),
        ]
        
        XCTAssertEqual(notes[0].timeStamp.inSeconds, 4.0)
        XCTAssertEqual(notes[0].timeStamp.inTicks.value, 1_920)
        
        XCTAssertEqual(notes[1].timeStamp.inSeconds, 5.0)
        XCTAssertEqual(notes[1].timeStamp.inTicks.value, 2_400)
        
        XCTAssertEqual(notes[2].timeStamp.inSeconds, 5.5)
        XCTAssertEqual(notes[2].timeStamp.inTicks.value, 2_640)
        
        XCTAssertEqual(notes[3].timeStamp.inSeconds, 6.0)
        XCTAssertEqual(notes[3].timeStamp.inTicks.value, 2_880)
        
        XCTAssertEqual(notes[4].timeStamp.inSeconds, 8.0)
        XCTAssertEqual(notes[4].timeStamp.inTicks.value, 3_840)
    }
    
    func test45BeatsPerMinute_GetTimeStamp_ReturnsConvertedValues() {
        let notes = [
            MidiNote(regularTimeStamp: 4.0, regularDuration: 1.0, note: 23, velocity: 10, channel: 2, beatsPerMinute: BeatsPerMinute(45)),
            MidiNote(regularTimeStamp: 5.0, regularDuration: 1.0, note: 23, velocity: 10, channel: 2, beatsPerMinute: BeatsPerMinute(45)),
            MidiNote(regularTimeStamp: 6.0, regularDuration: 1.0, note: 23, velocity: 10, channel: 2, beatsPerMinute: BeatsPerMinute(45)),
            MidiNote(regularTimeStamp: 8.0, regularDuration: 1.0, note: 23, velocity: 10, channel: 2, beatsPerMinute: BeatsPerMinute(45)),
            MidiNote(regularTimeStamp: 9.0, regularDuration: 1.0, note: 23, velocity: 10, channel: 2, beatsPerMinute: BeatsPerMinute(45)),
            ]
        
        XCTAssertEqual(notes[0].timeStamp.inSeconds, 5.333)
        XCTAssertEqual(notes[0].timeStamp.inTicks.value, 1_920)
        
        XCTAssertEqual(notes[1].timeStamp.inSeconds, 6.666)
        XCTAssertEqual(notes[1].timeStamp.inTicks.value, 2_400)
        
        XCTAssertEqual(notes[2].timeStamp.inSeconds, 8.0)
        XCTAssertEqual(notes[2].timeStamp.inTicks.value, 2_880)
        
        XCTAssertEqual(notes[3].timeStamp.inSeconds, 10.666)
        XCTAssertEqual(notes[3].timeStamp.inTicks.value, 3_840)
        
        XCTAssertEqual(notes[4].timeStamp.inSeconds, 12.0)
        XCTAssertEqual(notes[4].timeStamp.inTicks.value, 4_320)
    }
    
    func test85BeatsPerMinute_GetTimeStamp_ReturnsConvertedValues() {
        let notes = [
            MidiNote(regularTimeStamp: 4.0, regularDuration: 0.5, note: 23, velocity: 10, channel: 2, beatsPerMinute: BeatsPerMinute(85)),
            MidiNote(regularTimeStamp: 6.0, regularDuration: 0.25, note: 23, velocity: 10, channel: 2, beatsPerMinute: BeatsPerMinute(85)),
            MidiNote(regularTimeStamp: 6.25, regularDuration: 0.25, note: 23, velocity: 10, channel: 2, beatsPerMinute: BeatsPerMinute(85)),
            MidiNote(regularTimeStamp: 6.5, regularDuration: 0.25, note: 23, velocity: 10, channel: 2, beatsPerMinute: BeatsPerMinute(85)),
            MidiNote(regularTimeStamp: 6.75, regularDuration: 0.25, note: 23, velocity: 10, channel: 2, beatsPerMinute: BeatsPerMinute(85)),
            ]
        
        XCTAssertEqual(notes[0].timeStamp.inSeconds, 2.823)
        XCTAssertEqual(notes[0].timeStamp.inTicks.value, 1_920)
        
        XCTAssertEqual(notes[1].timeStamp.inSeconds, 4.235)
        XCTAssertEqual(notes[1].timeStamp.inTicks.value, 2_880)
        
        XCTAssertEqual(notes[2].timeStamp.inSeconds, 4.411)
        XCTAssertEqual(notes[2].timeStamp.inTicks.value, 3_000)
        
        XCTAssertEqual(notes[3].timeStamp.inSeconds, 4.588)
        XCTAssertEqual(notes[3].timeStamp.inTicks.value, 3120)
        
        XCTAssertEqual(notes[4].timeStamp.inSeconds, 4.764)
        XCTAssertEqual(notes[4].timeStamp.inTicks.value, 3240)
    }
}
