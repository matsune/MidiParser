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
        let track = midi.addTrack()
        track.add(note: MidiNote(timeStamp: 0, duration: 10, note: 50, velocity: 100, channel: 0))
        XCTAssertEqual(track.count, 1)
        
        track.add(notes: [
            MidiNote(timeStamp: 5, duration: 10, note: 40, velocity: 100, channel: 0),
            MidiNote(timeStamp: 10, duration: 10, note: 40, velocity: 100, channel: 0),
            MidiNote(timeStamp: 20, duration: 10, note: 40, velocity: 100, channel: 0)
        ])
        XCTAssertEqual(track.count, 4)
        
        track.cut(from: 0, to: 5)
        XCTAssertEqual(track.trackLength, 25)
        
        track.clearNotes(from: 0, to: 10)
        XCTAssertEqual(track.count, 1)
        
        track.clearNotes()
        XCTAssertEqual(track.count, 0)
        
        midi.remove(track: track)
        
        let tmp = URL(fileURLWithPath: NSTemporaryDirectory() + "tmp.mid")
        print(tmp)
        try! midi.writeData(to: tmp)
    }
}
