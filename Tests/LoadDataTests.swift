//
//  LoadDataTests.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2018/07/09.
//  Copyright © 2018 Yuma Matsune. All rights reserved.
//

@testable import MidiParser
import XCTest

class LoadDataTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLoadedMidi() {
        /*
         [MIDI_sample.mid](https://en.wikipedia.org/wiki/File:MIDI_sample.mid?qsrc=3044)
         */
        guard let url = Bundle(for: type(of: self)).url(forResource: "MIDI_sample", withExtension: "mid"),
            let data = try? Data(contentsOf: url) else {
            XCTFail()
            return
        }
        let midi = MidiData()
        midi.load(data: data)

        // sig: 4/4  bpm: 120
        XCTAssertEqual(midi.tempoTrack.timeSignatures[0].numerator, 4)
        XCTAssertEqual(midi.tempoTrack.timeSignatures[0].denominator, 2)
        XCTAssertEqual(midi.tempoTrack.timeSignatures[0].cc, 24)
        XCTAssertEqual(midi.tempoTrack.timeSignatures[0].bb, 8)
        XCTAssertEqual(midi.tempoTrack.extendedTempos[0].bpm, 120)

        XCTAssertEqual(midi.infoDictionary[MidiInfoKey.tempo] as! Int, 120)
        
        midi.tempoTrack.timeSignatures.removeAll()
        midi.tempoTrack.timeSignatures = [MidiTimeSignature(timeStamp: 0, numerator: 6, denominator: 3, cc: 24, bb: 8)]
        XCTAssertEqual(midi.infoDictionary[.timeSignature] as? String, "6/8")
        print(midi.infoDictionary)
        
        let noteCount = midi.noteTracks[1].count
        midi.noteTracks[1].deleteNote(at: 10)
        XCTAssertEqual(noteCount - 1, midi.noteTracks[1].count)
        midi.noteTracks[1].add(note: MidiNote(timeStamp: 10, duration: 1, note: 40, velocity: 10, channel: 0, releaseVelocity: 0))
        XCTAssertEqual(noteCount, midi.noteTracks[1].count)

        midi.noteTracks[1].trackName = "aaa"
        XCTAssertEqual(midi.noteTracks[1].trackName, "aaa")
        
        print(midi.noteTracks[1].trackLength)
        midi.noteTracks[1].trackLength = 500
        XCTAssertEqual(midi.noteTracks[1].trackLength, 500)
        
        let tmp = URL(fileURLWithPath: NSTemporaryDirectory() + "tmp.mid")
        print(tmp)
        try! midi.writeData(to: tmp)
    }
    
}
