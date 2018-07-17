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
        
        midi.tempoTrack.extendedTempos = [MidiExtendedTempo(timeStamp: 0, bpm: 200)]
        XCTAssertEqual(midi.infoDictionary[.tempo] as? Int, 200)
        
        midi.tempoTrack.timeSignatures = [MidiTimeSignature(timeStamp: 0, numerator: 6, denominator: 3, cc: 24, bb: 8)]
        XCTAssertEqual(midi.infoDictionary[.timeSignature] as? String, "6/8")
        
        XCTAssertEqual(midi.noteTracks.count, 5)
        XCTAssertEqual(midi.noteTracks[0].trackName, "Bass")
        XCTAssertEqual(midi.noteTracks[1].trackName, "Piano")
        XCTAssertEqual(midi.noteTracks[2].trackName, "Hi-hat only")
        XCTAssertEqual(midi.noteTracks[3].trackName, "Drums")
        XCTAssertEqual(midi.noteTracks[4].trackName, "Jazz Guitar")
        
        let firstTrack = midi.noteTracks[0]
        
        print(firstTrack[0])
        
        firstTrack.keySignatures.removeAll()
        firstTrack.keySignatures.append(MidiKeySignature(timeStamp: 0, key: .major(.A)))
        XCTAssertEqual(midi.infoDictionary[.keySignature] as? String, "A")
        
        let noteCount = firstTrack.count
        firstTrack.removeNote(at: 10)
        XCTAssertEqual(noteCount - 1, firstTrack.count)
        firstTrack.add(note: MidiNote(timeStamp: 10, duration: 1, note: 40, velocity: 10, channel: 0, releaseVelocity: 0))
        XCTAssertEqual(noteCount, firstTrack.count)
        
        XCTAssertEqual(midi.tempoTrack.timeResolution, 480)
        
        firstTrack.clearEvents(from: 0, to: firstTrack.trackLength)
        XCTAssert(midi.noteTracks[0].isEmpty)
        
        let tmp = URL(fileURLWithPath: NSTemporaryDirectory() + "tmp.mid")
        print(tmp)
//        try! midi.writeData(to: tmp)
    }
}
