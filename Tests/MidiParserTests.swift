//
//  MidiParserTests.swift
//  MidiParserTests
//
//  Created by Yuma Matsune on 2018/07/07.
//  Copyright © 2018 Yuma Matsune. All rights reserved.
//

@testable import MidiParser
import XCTest

final class MidiParserTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testWrite() {
        let midi = MidiData()
        let track1 = midi.addTrack()
        track1.add(note: MidiNote(timeStamp: 0, duration: 10, note: 50, velocity: 100, channel: 0))
        XCTAssertEqual(track1.count, 1)
        
        track1.add(notes: [
            MidiNote(timeStamp: 5, duration: 10, note: 40, velocity: 100, channel: 0),
            MidiNote(timeStamp: 10, duration: 10, note: 40, velocity: 100, channel: 0),
            MidiNote(timeStamp: 20, duration: 10, note: 40, velocity: 100, channel: 0)
        ])
        XCTAssertEqual(track1.count, 4)
        
        track1.cut(from: 0, to: 5)
        XCTAssertEqual(track1.trackLength, 25)
        
        track1.clearNotes(from: 0, to: 10)
        XCTAssertEqual(track1.count, 1)
        
        track1.clearNotes()
        XCTAssertEqual(track1.count, 0)
        
        track1.add(notes: [
            MidiNote(timeStamp: 0, duration: 10, note: 40, velocity: 100, channel: 0),
            MidiNote(timeStamp: 5, duration: 10, note: 40, velocity: 100, channel: 0)
        ])
        
        let track2 = midi.addTrack()
        track2.add(notes: [
            MidiNote(timeStamp: 10, duration: 10, note: 40, velocity: 100, channel: 0),
            MidiNote(timeStamp: 15, duration: 10, note: 40, velocity: 100, channel: 0)
        ])
        
        track1.merge(from: 0, to: 10, destTrack: track2, insertTime: 0)
        
        XCTAssertEqual(track1.notes.count, 2)
        XCTAssertEqual(track2.notes.count, 4)
        
//        midi.remove(track: track)
//
        let tmp = URL(fileURLWithPath: NSTemporaryDirectory() + "tmp.mid")
        print(tmp)
        try! midi.writeData(to: tmp)
    }
}
