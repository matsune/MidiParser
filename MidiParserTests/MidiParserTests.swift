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
    
    func testMidi_sample_mid() {
        /*
         [MIDI_sample.mid](https://en.wikipedia.org/wiki/File:MIDI_sample.mid?qsrc=3044)
         
         - 4 / 4
         - 5 instrument tracks
         - 120 bpm
         
         */
        guard let url = Bundle(for: type(of: self)).url(forResource: "MIDI_sample", withExtension: "mid"),
            let data = try? Data(contentsOf: url) else {
            XCTFail()
            return
        }
        let midi = MidiData(data: data)
        print(midi.infoDictionary)
        XCTAssertEqual(midi.tempoTrack?.timeSignatures.count, 1)
        XCTAssertEqual(midi.tempoTrack?.timeSignatures[0].numerator, 4)
        XCTAssertEqual(midi.tempoTrack?.timeSignatures[0].denominator, 4)
        XCTAssertEqual(midi.tempoTrack?.timeSignatures[0].cc, 24)
        XCTAssertEqual(midi.tempoTrack?.timeSignatures[0].bb, 8)
        XCTAssertEqual(midi.tempoTrack?.extendedTempos[0].bpm, 120)
        XCTAssertEqual(midi.sequenceType, .beats)
    }
}
