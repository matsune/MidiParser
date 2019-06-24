//
//  MidiSequenceTests.swift
//  MidiParser iOSTests
//
//  Created by Vladimir Vybornov on 6/21/19.
//  Copyright © 2019 Yuma Matsune. All rights reserved.
//

import AudioToolbox
import XCTest
@testable import MidiParser

final class MidiSequenceTests: XCTestCase {
    
    private var sut: MidiSequence!
    
    override func setUp() {
        sut = MidiSequence()
        sut.load(data: FakeMidiData.midiDataTempo60)
    }
    
    override func tearDown() {
        sut = nil
    }
    
}

//MARK: - Init With Fake Midi
extension MidiSequenceTests {
    
    func testFakeMidiData_Load_ReturnsInstance() {
        XCTAssertNotNil(sut)
    }

    func testFakeMidiData_Load_ReturnsInfoDictionary() {
        XCTAssertEqual(sut.infoDictionary[.title] as! String, "Main")
        XCTAssertEqual(sut.infoDictionary[.tempo] as! Int, 60)
        XCTAssertEqual(sut.infoDictionary[.timeSignature] as! String, "4/4")
    }
    
    func testFakeMidiData_Load_ReturnsSequenceProperties() {
        XCTAssertEqual(sut.fileFormat, .type1)
        XCTAssertEqual(sut.trackCount, 2)
        
        XCTAssertNotNil(sut.sequenceType)
        XCTAssertNotNil(sut.tempoTrack)
    }
    
}

//MARK: - Mutate
extension MidiSequenceTests {
    
    func testFakeMidiData_NewAndDisposeTrack_ReturnsSuccess() {
        XCTAssertEqual(sut.trackCount, 2)
        let newTrack = sut.newTrack()
        
        XCTAssertEqual(sut.trackCount, 3)
        XCTAssertEqual(sut.index(ofTrack: newTrack.musicTrack), 2)
    }

}

//MARK: - Create New Sequence
extension MidiSequenceTests {
    
    func testInit_ReturnsEmptyInstance() {
        let sequence = MidiSequence()
    
        XCTAssertEqual(sequence.fileFormat, .type1)
        XCTAssertEqual(sequence.infoDictionary[.tempo] as! Int, 120)
        XCTAssertEqual(sequence.trackCount, 0)
        XCTAssertNotNil(sequence.tempoTrack)
        
        XCTAssertEqual(sequence.sequenceType, MusicSequenceType.beats)
        
        sequence.sequenceType = MusicSequenceType.samples
        XCTAssertEqual(sequence.sequenceType, MusicSequenceType.samples)
        
        XCTAssertEqual(sequence.fileFormat.description, "A type 1 files may contain any number of tracks, running synchronously")
    }
}
