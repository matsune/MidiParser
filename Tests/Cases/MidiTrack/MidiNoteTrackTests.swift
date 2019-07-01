//
//  MidiTrackTests.swift
//  MidiParser iOSTests
//
//  Created by Vladimir Vybornov on 6/20/19.
//  Copyright © 2019 Yuma Matsune. All rights reserved.
//

import AudioToolbox
import XCTest
@testable import MidiParser

final class MidiNoteTrackTests: XCTestCase {

    private var sequence: MidiSequence!

    override func setUp() {
        sequence = MidiSequence()
        sequence.load(data: FakeMidiData.midiDataTempo60)
    }

    override func tearDown() {
        sequence = nil
    }
    
}

//MARK: - Get Propterties
extension MidiNoteTrackTests {
    
    func testInitFakeTrack_ReturnsProperties() {
        let firstTrack = sequence.track(at: 0)!
        let sut = MidiNoteTrack(musicTrack: firstTrack)
        
        XCTAssertEqual(sut.count, 48)
        XCTAssertEqual(sut.startIndex, 0)
        XCTAssertEqual(sut.endIndex, 48)
        XCTAssertEqual(sut.trackLength, 51.0)
        
        XCTAssertTrue(sut.keySignatures.isEmpty)
        XCTAssertTrue(sut.lyrics.isEmpty)
        
        XCTAssertEqual(sut.loopInfo.loopDuration, 0.0)
        XCTAssertEqual(sut.loopInfo.numberOfLoops, 1)
        
        XCTAssertEqual(sut.name, "Main")
        XCTAssertEqual(sut.offsetTime, 0)
    
        XCTAssertFalse(sut.isSolo)
        XCTAssertFalse(sut.isMute)
        XCTAssertFalse(sut.isEmpty)
    }
    
    func testInitFakeTrack_ReturnsNotes() {
        let firstTrack = sequence.track(at: 0)!
        let sut = MidiNoteTrack(musicTrack: firstTrack)
        
        XCTAssertEqual(sut.notes.count, 48)
        XCTAssertEqual(sut.notes[0], MidiNote(regularTimeStamp: 4.0, regularDuration: 1.0, note: 57, velocity: 72, channel: 0, releaseVelocity: 64))
        XCTAssertEqual(sut.notes[1], MidiNote(regularTimeStamp: 5.0, regularDuration: 0.5, note: 57, velocity: 72, channel: 0, releaseVelocity: 64))
        XCTAssertEqual(sut.notes[2], MidiNote(regularTimeStamp: 5.5, regularDuration: 0.5, note: 57, velocity: 72, channel: 0, releaseVelocity: 64))
    }
    
    func testInitFakeTrack_LoopIterator_ReturnsEvents() {
        let firstTrack = sequence.track(at: 0)!
        let sut = MidiNoteTrack(musicTrack: firstTrack)
    
        var events = [EventInfo]()
        var i = 0
        sut.iterator.enumerate { info, finished, next in
            if i > 4 {
              return
            }
            events.append(info)
            print(info, finished, next)
            i += 1
        }
        
        XCTAssertEqual(events[0].type, 5)
        XCTAssertEqual(events[0].timeStamp, 0.0)
        
        XCTAssertEqual(events[1].type, 7)
        XCTAssertEqual(events[1].timeStamp, 0.0)
        
        XCTAssertEqual(events[2].type, 6)
        XCTAssertEqual(events[2].timeStamp, 4.0)
        
        XCTAssertEqual(events[3].type, 6)
        XCTAssertEqual(events[3].timeStamp, 5.0)
        
        XCTAssertEqual(events[4].type, 6)
        XCTAssertEqual(events[4].timeStamp, 5.5)
    }
    
    func testInitFakeTrack_GetNotes_ReturnsSuccess() {
        let firstTrack = sequence.track(at: 0)!
        let sut = MidiNoteTrack(musicTrack: firstTrack)
        
        let note = sut[0]        
        XCTAssertEqual(note.channel, 0)
        XCTAssertEqual(note.duration.inSeconds, 1.0)
        XCTAssertEqual(note.note, 57)
        XCTAssertEqual(note.releaseVelocity, 64)
        XCTAssertEqual(note.timeStamp.inSeconds, 4.0)
        XCTAssertEqual(note.timeStamp.inTicks.value, 1920)
    }
    
}

//MARK: - Mutating Properties
extension MidiNoteTrackTests {
    
    func testInitFakeTrack_MutateKeySignatures_ReturnsSuccess() {
        let firstTrack = sequence.track(at: 0)!
        let sut = MidiNoteTrack(musicTrack: firstTrack)
        
        XCTAssertTrue(sut.keySignatures.isEmpty)
        
        sut.keySignatures = [MidiKeySignature(timeStamp: 1.5, sf: 1, isMajor: false)]
        XCTAssertFalse(sut.keySignatures.isEmpty)
        XCTAssertEqual(sut.keySignatures[0].timeStamp, 1.5)
        XCTAssertEqual(sut.keySignatures[0].metaType.rawValue, 89)
        XCTAssertEqual(sut.keySignatures[0].keySig, .minor(.E))
    }
    
    func testInitFakeTrack_MutateLyrics_ReturnsSuccess() {
        let firstTrack = sequence.track(at: 0)!
        let sut = MidiNoteTrack(musicTrack: firstTrack)
        
        XCTAssertTrue(sut.lyrics.isEmpty)
        
        sut.lyrics = [MidiLyric(timeStamp: 0.1, str: "lyrics")]
        
        XCTAssertFalse(sut.lyrics.isEmpty)
        XCTAssertEqual(sut.lyrics[0].timeStamp, 0.1)
        XCTAssertEqual(sut.lyrics[0].str, "lyrics")
        XCTAssertEqual(sut.lyrics[0].bytes, [108, 121, 114, 105, 99, 115])
        XCTAssertEqual(sut.lyrics[0].metaType, .lyric)
    }
    
    func testInitFakeTrack_MutateOffsetTime_ReturnsSuccess() {
        let firstTrack = sequence.track(at: 0)!
        let sut = MidiNoteTrack(musicTrack: firstTrack)
        
        XCTAssertEqual(sut.offsetTime, 0.0)
        sut.offsetTime = 1.2
        XCTAssertEqual(sut.offsetTime, 1.2)
    }
    
    func testInitFakeTrack_MutateTrackLength_ReturnsSuccess() {
        let newTrack = sequence.newTrack()
        let sut = MidiNoteTrack(musicTrack: newTrack.musicTrack)
        
        XCTAssertEqual(sut.trackLength, 0.0)

        sut.trackLength = 1.2
        XCTAssertEqual(sut.trackLength, 1.2)
    }
    
    func testInitFakeTrack_MutateLoopInfo_ReturnsSuccess() {
        let newTrack = sequence.newTrack()
        let sut = MidiNoteTrack(musicTrack: newTrack.musicTrack)
        
        XCTAssertEqual(sut.loopInfo.loopDuration, 0.0)
        XCTAssertEqual(sut.loopInfo.numberOfLoops, 1)
        
        sut.loopInfo = MusicTrackLoopInfo(loopDuration: 1.2, numberOfLoops: 3)
        XCTAssertEqual(sut.loopInfo.loopDuration, 1.2)
        XCTAssertEqual(sut.loopInfo.numberOfLoops, 3)
    }

    func testInitFakeTrack_MutateName_ReturnsSuccess() {
        let newTrack = sequence.newTrack()
        let sut = MidiNoteTrack(musicTrack: newTrack.musicTrack)
        
        XCTAssertEqual(sut.name, "")
        
        sut.name = "NewTrack"
        sut.reload()
        XCTAssertEqual(sut.name, "NewTrack")
    }
    
    func testInitFakeTrack_MutateIsSolo_ReturnsSuccess() {
        let newTrack = sequence.newTrack()
        let sut = MidiNoteTrack(musicTrack: newTrack.musicTrack)
        
        XCTAssertFalse(sut.isSolo)
        XCTAssertFalse(sut.isMute)
        
        sut.isSolo = true
        sut.isMute = true
        XCTAssertTrue(sut.isSolo)
        XCTAssertTrue(sut.isMute)
    }
    
    func testInitFakeTrack_MutateAutomatedParameters_ReturnsSuccess() {
        let newTrack = sequence.newTrack()
        let sut = MidiNoteTrack(musicTrack: newTrack.musicTrack)
        
        XCTAssertEqual(sut.automatedParameters, 0)
        
        sut.automatedParameters = 1
        XCTAssertEqual(sut.automatedParameters, 1)
    }
}

//MARK: - Mutating Notes
extension MidiNoteTrackTests {
    
    func testInitEmptyTrack_AddNotes_ReturnsSuccess() {
        let newTrack = sequence.newTrack()
        let sut = MidiNoteTrack(musicTrack: newTrack.musicTrack)
        
        XCTAssertEqual(sut.notes.count, 0)
        
        sut.add(note: MidiNote(regularTimeStamp: 0.1, regularDuration: 0.2, note: 20, velocity: 34, channel: 0, releaseVelocity: 0))
        sut.add(note: MidiNote(regularTimeStamp: 1.1, regularDuration: 1.2, note: 21, velocity: 134, channel: 1, releaseVelocity: 2))
        XCTAssertEqual(sut.notes.count, 2)
        
        sut.addNote(timeStamp: 2.0, duration: 0.5, note: 34, velocity: 12, channel: 2, releaseVelocity: 134)
        XCTAssertEqual(sut.notes.count, 3)
        
        sut.add(notes: [MidiNote(regularTimeStamp: 0.1, regularDuration: 0.2, note: 20, velocity: 34, channel: 0, releaseVelocity: 0), MidiNote(regularTimeStamp: 1.1, regularDuration: 1.2, note: 21, velocity: 134, channel: 1, releaseVelocity: 2)])
        XCTAssertEqual(sut.notes.count, 5)
    }
    
    func testInitEmptyTrack_RemoveNote_ReturnsSuccess() {
        let newTrack = sequence.newTrack()
        let sut = MidiNoteTrack(musicTrack: newTrack.musicTrack)
        
        XCTAssertEqual(sut.notes.count, 0)
        
        sut.add(note: MidiNote(regularTimeStamp: 0.1, regularDuration: 0.2, note: 20, velocity: 34, channel: 0, releaseVelocity: 0))
        sut.add(note: MidiNote(regularTimeStamp: 1.1, regularDuration: 1.2, note: 21, velocity: 134, channel: 1, releaseVelocity: 2))
        XCTAssertEqual(sut.notes.count, 2)
        
        sut.removeNote(at: 1)
        XCTAssertEqual(sut.notes.count, 1)
        XCTAssertEqual(sut.notes[0].timeStamp.inSeconds, 0.1)
        //XCTAssertEqual(sut.notes[0].timeStamp.inSeconds, 0.1)
    }
    
    func testInitEmptyTrack_RemoveNote1_ReturnsSuccess() {
        let newTrack = sequence.newTrack()
        let sut = MidiNoteTrack(musicTrack: newTrack.musicTrack)
        
        XCTAssertEqual(sut.notes.count, 0)
        
        sut.add(note: MidiNote(regularTimeStamp: 0.1, regularDuration: 0.2, note: 20, velocity: 34, channel: 0, releaseVelocity: 0))
        sut.add(note: MidiNote(regularTimeStamp: 1.1, regularDuration: 1.2, note: 21, velocity: 134, channel: 1, releaseVelocity: 2))
        XCTAssertEqual(sut.notes.count, 2)
        
        sut.removeNote(at: 1)
        XCTAssertEqual(sut.notes.count, 1)
        XCTAssertEqual(sut.notes[0].timeStamp.inSeconds, 0.1)
    }
    
}

//MARK: - Clear Notes
extension MidiNoteTrackTests {
    
    func testInitEmptyTrack_ClearNotes_ReturnsSuccess() {
        let newTrack = sequence.newTrack()
        let sut = MidiNoteTrack(musicTrack: newTrack.musicTrack)
        
        sut.add(note: MidiNote(regularTimeStamp: 0.1, regularDuration: 0.2, note: 20, velocity: 34, channel: 0, releaseVelocity: 0))
        sut.add(note: MidiNote(regularTimeStamp: 1.1, regularDuration: 1.2, note: 21, velocity: 134, channel: 1, releaseVelocity: 2))
        XCTAssertEqual(sut.notes.count, 2)
        
        sut.clearNotes()
        XCTAssertEqual(sut.notes.count, 0)
    }
    
    func testInitEmptyTrack_ClearNoteRange_ReturnsSuccess() {
        let newTrack = sequence.newTrack()
        let sut = MidiNoteTrack(musicTrack: newTrack.musicTrack)
        
        XCTAssertEqual(sut.notes.count, 0)
        
        sut.add(notes: [
            MidiNote(regularTimeStamp: 0.1, regularDuration: 0.2, note: 20, velocity: 34, channel: 0, releaseVelocity: 0),
            MidiNote(regularTimeStamp: 0.2, regularDuration: 1.2, note: 21, velocity: 134, channel: 1, releaseVelocity: 2),
            MidiNote(regularTimeStamp: 0.4, regularDuration: 1.2, note: 21, velocity: 134, channel: 1, releaseVelocity: 2),
            MidiNote(regularTimeStamp: 0.6, regularDuration: 1.2, note: 21, velocity: 134, channel: 1, releaseVelocity: 2),
            MidiNote(regularTimeStamp: 0.8, regularDuration: 1.2, note: 21, velocity: 134, channel: 1, releaseVelocity: 2)
        ])
        
        XCTAssertEqual(sut.notes.count, 5)
        
        sut.clearNotes(from: 0.2, to: 0.6)
        XCTAssertEqual(sut.notes.count, 3)
    }
    
}

extension MidiNote: Equatable {
    
//    public static func == (lhs: MidiNote, rhs: MidiNote) -> Bool {
//        return lhs.channel == rhs.channel && lhs.duration == rhs.duration && lhs.note == rhs.note && lhs.releaseVelocity == rhs.releaseVelocity && lhs.timeStamp.inSeconds == rhs.timeStamp.inSeconds
//    }
    
    public static func == (lhs: MidiNote, rhs: MidiNote) -> Bool {
        return lhs.channel == rhs.channel && lhs.duration.inSeconds == rhs.duration.inSeconds && lhs.note == rhs.note && lhs.releaseVelocity == rhs.releaseVelocity && lhs.timeStamp.inSeconds == rhs.timeStamp.inSeconds
    }
}
