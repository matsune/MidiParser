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
        
        print(sequence.infoDictionary)
        print(sequence.sequenceType.rawValue)
        print(sequence.tempoTrack)
        print(sequence.trackCount)
        
    }
    
//    func test() {
//        let sequence = MidiSequence()
//        sequence.load(data: FakeMidiData.midiDataTempo85)
//        
//        print(sequence.trackCount)
//        //let t = sut.track(at: 0)
//        //print
//        print(sequence.infoDictionary)
//        print(sequence.tempoTrack.debugDescription)
//        
//        let parser85 = MidiData()
//        parser85.load(data: FakeMidiData.midiDataTempo85)
//        
//        print(parser85.tempoTrack.extendedTempos[0].bpm)
//        print(Int(parser85.tempoTrack.extendedTempos[0].bpm))
//        print(parser85.tempoTrack.timeResolution)
//        print(parser85.tempoTrack.timeSignatures)
//    }
    
}

private extension MidiSequenceTests {
    
    func makeSequence() -> MusicSequence {
        var sequencePtr: MusicSequence?
        NewMusicSequence(&sequencePtr)
        
        return sequencePtr!
    }
    
    func makeTrack(musicSequence: MusicSequence) -> MusicTrack {
        var musicTrackPtr: MusicTrack?
        MusicSequenceNewTrack(musicSequence, &musicTrackPtr)
        
        return musicTrackPtr!
    }
    
}
