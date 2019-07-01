//
//  MidiDataTests.swift
//  MidiParser iOSTests
//
//  Created by Vladimir Vybornov on 6/22/19.
//  Copyright © 2019 Yuma Matsune. All rights reserved.
//

import AudioToolbox
import XCTest
@testable import MidiParser

final class MidiDataTests: XCTestCase {
    
    private var sut: MidiData!
        
    override func setUp() {
        sut = MidiData()
    }

    override func tearDown() {
        sut = nil
    }

}

//MARK: - Tempo 60 (beatsPerMinute), TicksPerBeat 480
extension MidiDataTests {
    
    func testFakeMidiDataWithTempo60_Load_ReturnsProperties() {
        sut.load(data: FakeMidiData.midiDataTempo60)
        
        XCTAssertEqual(sut.beatsPerMinute.value, 60)
        XCTAssertEqual(sut.ticksPerBeat.value, 480)
        
        XCTAssertEqual(sut.format, 1)
        XCTAssertEqual(sut.noteTracks.count, 2)
        XCTAssertEqual(sut.sequenceType, MusicSequenceType.beats)
    
        XCTAssertEqual(sut.infoDictionary[.title] as! String, "Main")
        XCTAssertEqual(sut.infoDictionary[.timeSignature] as! String, "4/4")
        XCTAssertEqual(sut.infoDictionary[.tempo] as! Int, 60)
        
        XCTAssertEqual(sut.tempoTrack.timeResolution, 480)
        
        XCTAssertEqual(sut.tempoTrack.timeSignatures[0].timeStamp, 0.0)
    }
    
    func testFakeMidiDataWithTempo60_Load_ReturnsTrackNames() {
        sut.load(data: FakeMidiData.midiDataTempo60)
        
        XCTAssertEqual(sut.noteTracks[0].name, "Main")
        XCTAssertEqual(sut.noteTracks[1].name, "Acoustic Piano")
    }
    
    func testFakeMidiDataWithTempo60_Load_ReturnsNotes() {
        sut.load(data: FakeMidiData.midiDataTempo60)

        XCTAssertEqual(sut.noteTracks.count, 2)
        
        XCTAssertEqual(sut.noteTracks[0][0].timeStamp.inSeconds, 4.0)
        XCTAssertEqual(sut.noteTracks[0][0].timeStamp.inTicks.value, 1_920)
        XCTAssertEqual(sut.noteTracks[0][0].duration.inSeconds, 1.0)
        XCTAssertEqual(sut.noteTracks[0][0].duration.inTicks.value, 480)
        
        XCTAssertEqual(sut.noteTracks[0][1].timeStamp.inSeconds, 5.0)
        XCTAssertEqual(sut.noteTracks[0][1].timeStamp.inTicks.value, 2_400)
        XCTAssertEqual(sut.noteTracks[0][1].duration.inSeconds, 0.5)
        XCTAssertEqual(sut.noteTracks[0][1].duration.inTicks.value, 240)
        
        XCTAssertEqual(sut.noteTracks[0][2].timeStamp.inSeconds, 5.5)
        XCTAssertEqual(sut.noteTracks[0][2].timeStamp.inTicks.value, 2640)
        XCTAssertEqual(sut.noteTracks[0][2].duration.inSeconds, 0.5)
        XCTAssertEqual(sut.noteTracks[0][2].duration.inTicks.value, 240)
        
        XCTAssertEqual(sut.noteTracks[1][0].timeStamp.inSeconds, 0.0)
        XCTAssertEqual(sut.noteTracks[1][0].timeStamp.inTicks.value, 0)
        XCTAssertEqual(sut.noteTracks[1][0].duration.inSeconds, 1.0)
        XCTAssertEqual(sut.noteTracks[1][0].duration.inTicks.value, 480)
        
        XCTAssertEqual(sut.noteTracks[1][1].timeStamp.inSeconds, 1.0)
        XCTAssertEqual(sut.noteTracks[1][1].timeStamp.inTicks.value, 480)
        XCTAssertEqual(sut.noteTracks[1][1].duration.inSeconds, 0.5)
        XCTAssertEqual(sut.noteTracks[1][1].duration.inTicks.value, 240)
        
        XCTAssertEqual(sut.noteTracks[1][2].timeStamp.inSeconds, 1.5)
        XCTAssertEqual(sut.noteTracks[1][2].timeStamp.inTicks.value, 720)
        XCTAssertEqual(sut.noteTracks[1][2].duration.inSeconds, 0.5)
        XCTAssertEqual(sut.noteTracks[1][2].duration.inTicks.value, 240)
    }
    
}

//MARK: - Tempo 45 (beatsPerMinute), TicksPerBeat 480
extension MidiDataTests {
    
    func testFakeMidiDataWithTempo45_Load_ReturnsProperties() {
        sut.load(data: FakeMidiData.midiDataTempo45)
        
        XCTAssertEqual(sut.beatsPerMinute.value, 45)
        XCTAssertEqual(sut.ticksPerBeat.value, 480)
        
        XCTAssertEqual(sut.format, 1)
        XCTAssertEqual(sut.noteTracks.count, 2)
        
        XCTAssertEqual(sut.infoDictionary[.title] as! String, "Main")
        XCTAssertEqual(sut.infoDictionary[.timeSignature] as! String, "4/4")
        XCTAssertEqual(Int(sut.infoDictionary[.tempo] as! Double), 45)
        
        XCTAssertEqual(sut.tempoTrack.timeResolution, 480)
        
        XCTAssertEqual(sut.tempoTrack.timeSignatures[0].timeStamp, 0.0)
    }
    
    func testFakeMidiDataWithTempo45_Load_ReturnsTrackNames() {
        sut.load(data: FakeMidiData.midiDataTempo45)
        
        XCTAssertEqual(sut.noteTracks[0].name, "Main")
        XCTAssertEqual(sut.noteTracks[1].name, "Second")
    }
    
    func testFakeMidiDataWithTempo45_Load_ReturnsNotes() {
        sut.load(data: FakeMidiData.midiDataTempo45)
        
        XCTAssertEqual(sut.noteTracks.count, 2)
        
        XCTAssertEqual(sut.noteTracks[0][0].timeStamp.inSeconds, 5.333)
        XCTAssertEqual(sut.noteTracks[0][0].timeStamp.inTicks.value, 1_920)
        XCTAssertEqual(sut.noteTracks[0][0].duration.inSeconds, 1.333)
        XCTAssertEqual(sut.noteTracks[0][0].duration.inTicks.value, 480)
        
        
        XCTAssertEqual(sut.noteTracks[0][1].timeStamp.inSeconds, 6.666)
        XCTAssertEqual(sut.noteTracks[0][1].timeStamp.inTicks.value, 2_400)
        XCTAssertEqual(sut.noteTracks[0][1].duration.inSeconds, 1.333)
        XCTAssertEqual(sut.noteTracks[0][1].duration.inTicks.value, 480)
        
        XCTAssertEqual(sut.noteTracks[0][2].timeStamp.inSeconds, 8.0)
        XCTAssertEqual(sut.noteTracks[0][2].timeStamp.inTicks.value, 2_880)
        XCTAssertEqual(sut.noteTracks[0][2].duration.inSeconds, 1.333)
        XCTAssertEqual(sut.noteTracks[0][2].duration.inTicks.value, 480)
       

        XCTAssertEqual(sut.noteTracks[1][0].timeStamp.inSeconds, 0.0)
        XCTAssertEqual(sut.noteTracks[1][0].timeStamp.inTicks.value, 0)
        XCTAssertEqual(sut.noteTracks[1][0].duration.inSeconds, 1.333)
        XCTAssertEqual(sut.noteTracks[1][0].duration.inTicks.value, 480)
        
        XCTAssertEqual(sut.noteTracks[1][1].timeStamp.inSeconds, 1.333)
        XCTAssertEqual(sut.noteTracks[1][1].timeStamp.inTicks.value, 480)
        XCTAssertEqual(sut.noteTracks[1][1].duration.inSeconds, 1.333)
        XCTAssertEqual(sut.noteTracks[1][1].duration.inTicks.value, 480)
        
        XCTAssertEqual(sut.noteTracks[1][2].timeStamp.inSeconds, 2.666)
        XCTAssertEqual(sut.noteTracks[1][2].timeStamp.inTicks.value, 960)
        XCTAssertEqual(sut.noteTracks[1][2].duration.inSeconds, 0.666)
        XCTAssertEqual(sut.noteTracks[1][2].duration.inTicks.value, 240)
    }
    
}

//MARK: - Tempo 85 (beatsPerMinute), TicksPerBeat 480
extension MidiDataTests {
    
    func testFakeMidiDataWithTempo85_Load_ReturnsProperties() {
        sut.load(data: FakeMidiData.midiDataTempo85)
        
        XCTAssertEqual(sut.beatsPerMinute.value, 85)
        XCTAssertEqual(sut.ticksPerBeat.value, 480)
        
        XCTAssertEqual(sut.format, 1)
        XCTAssertEqual(sut.noteTracks.count, 10)
        
        XCTAssertEqual(sut.infoDictionary[.title] as! String, "Main")
        XCTAssertEqual(sut.infoDictionary[.timeSignature] as! String, "4/4")
        XCTAssertEqual(Int(sut.infoDictionary[.tempo] as! Double), 85)
        
        XCTAssertEqual(sut.tempoTrack.timeResolution, 480)
        
        XCTAssertEqual(sut.tempoTrack.timeSignatures[0].timeStamp, 0.0)
    }
    
    func testFakeMidiDataWithTempo85_Load_ReturnsTrackNames() {
        sut.load(data: FakeMidiData.midiDataTempo85)
        
        XCTAssertEqual(sut.noteTracks[0].name, "Main")
        XCTAssertEqual(sut.noteTracks[1].name, "Breath")
        XCTAssertEqual(sut.noteTracks[2].name, "Electric Guitar")
        XCTAssertEqual(sut.noteTracks[3].name, "Electric Bass")
        XCTAssertEqual(sut.noteTracks[4].name, "English Horn")
        XCTAssertEqual(sut.noteTracks[5].name, "Synthesizer")
        XCTAssertEqual(sut.noteTracks[6].name, "Drums")
        XCTAssertEqual(sut.noteTracks[7].name, "Hand Clap")
        XCTAssertEqual(sut.noteTracks[8].name, "Baritone Voice")
        XCTAssertEqual(sut.noteTracks[9].name, "Bass Voice")
    }
    
    func testFakeMidiDataWithTempo85_Load_ReturnsNotes() {
        sut.load(data: FakeMidiData.midiDataTempo85)
        
        XCTAssertEqual(sut.noteTracks.count, 10)
        
        XCTAssertEqual(sut.noteTracks[0][0].timeStamp.inSeconds, 2.823)
        XCTAssertEqual(sut.noteTracks[0][0].timeStamp.inTicks.value, 1_920)
        XCTAssertEqual(sut.noteTracks[0][0].duration.inSeconds, 0.352)
        XCTAssertEqual(sut.noteTracks[0][0].duration.inTicks.value, 240)
        
        XCTAssertEqual(sut.noteTracks[0][1].timeStamp.inSeconds, 4.235)
        XCTAssertEqual(sut.noteTracks[0][1].timeStamp.inTicks.value, 2_880)
        XCTAssertEqual(sut.noteTracks[0][1].duration.inSeconds, 0.176)
        XCTAssertEqual(sut.noteTracks[0][1].duration.inTicks.value, 120)
        
        XCTAssertEqual(sut.noteTracks[0][2].timeStamp.inSeconds, 4.411)
        XCTAssertEqual(sut.noteTracks[0][2].timeStamp.inTicks.value, 3_000)
        XCTAssertEqual(sut.noteTracks[0][2].duration.inSeconds, 0.176)
        XCTAssertEqual(sut.noteTracks[0][2].duration.inTicks.value, 120)
        
        XCTAssertEqual(sut.noteTracks[1][0].timeStamp.inSeconds, 2.47)
        XCTAssertEqual(sut.noteTracks[1][0].timeStamp.inTicks.value, 1_680)
        XCTAssertEqual(sut.noteTracks[1][0].duration.inSeconds, 0.352)
        XCTAssertEqual(sut.noteTracks[1][0].duration.inTicks.value, 240)
        
        XCTAssertEqual(sut.noteTracks[1][1].timeStamp.inSeconds, 5.294)
        XCTAssertEqual(sut.noteTracks[1][1].timeStamp.inTicks.value, 3_600)
        XCTAssertEqual(sut.noteTracks[1][1].duration.inSeconds, 0.352)
        XCTAssertEqual(sut.noteTracks[1][1].duration.inTicks.value, 240)
        
        XCTAssertEqual(sut.noteTracks[1][2].timeStamp.inSeconds, 8.117)
        XCTAssertEqual(sut.noteTracks[1][2].timeStamp.inTicks.value, 5_520)
        XCTAssertEqual(sut.noteTracks[1][2].duration.inSeconds, 0.352)
        XCTAssertEqual(sut.noteTracks[1][2].duration.inTicks.value, 240)
    }
    
}

//MARK: - Init and Mutate Midi Data
extension MidiDataTests {
    
    func testInit_Properties_ReturnsInstance() {
        let midiData = MidiData()
        
        XCTAssertEqual(midiData.sequenceType, MusicSequenceType.beats)
        XCTAssertEqual(midiData.format, 1)
        XCTAssertEqual(midiData.infoDictionary[.tempo] as! Int, 120)
        XCTAssertEqual(midiData.ticksPerBeat.value, 480)
        XCTAssertEqual(midiData.beatsPerMinute.value, 60)
        
        midiData.sequenceType = MusicSequenceType.samples
        XCTAssertEqual(midiData.sequenceType, MusicSequenceType.samples)
    }
    
    func testInit_CreateData_ReturnsData() {
        let midiData = MidiData()
        
        guard let data = midiData.createData() else {
            XCTFail("Data is incorrect")
            return
        }
        
        XCTAssertNotNil(data)
        XCTAssertTrue(data.count > 0)
    }
    
    func testInit_AddRemoveTrack_ReturnsSuccess() {
        let midiData = MidiData()
        
        XCTAssertEqual(midiData.noteTracks.count, 0)
        
        midiData.addTrack()
        XCTAssertEqual(midiData.noteTracks.count, 1)
        
        midiData.addTrack()
        XCTAssertEqual(midiData.noteTracks.count, 2)
        
        midiData.removeTrack(at: 0)
        XCTAssertEqual(midiData.noteTracks.count, 1)
        
        let newTrack = midiData.addTrack()
        XCTAssertEqual(midiData.noteTracks.count, 2)
        XCTAssertTrue(newTrack.name.isEmpty)
        
        midiData.remove(track: newTrack)
        XCTAssertEqual(midiData.noteTracks.count, 1)
    }
    
    func testInit_DisposeTrack_ReturnsSuccess() {
        let midiData = MidiData()
        
        XCTAssertEqual(midiData.noteTracks.count, 0)
        
        midiData.addTrack()
        midiData.addTrack()
        XCTAssertEqual(midiData.noteTracks.count, 2)
        
        midiData.disposeTracks()
        XCTAssertEqual(midiData.noteTracks.count, 0)
    }
}

//MARK: - Midi Duration
extension MidiDataTests {
    
    func testFakeMidiTempo60_GetDuration_Returns62() {
        sut.load(data: FakeMidiData.midiDataTempo60)
        
        XCTAssertEqual(sut.duration.inSeconds, 52.0)
        XCTAssertEqual(sut.duration.inTicks.value, 24_960)
    }
    
    func testFakeMidiTempo45_GetDuration_Returns64() {
        sut.load(data: FakeMidiData.midiDataTempo45)
        
        XCTAssertEqual(sut.duration.inSeconds, 64.0)
        XCTAssertEqual(sut.duration.inTicks.value, 23_040)
    }
    
    func testFakeMidiTempo85_GetDuration_Returns50_82() {
        sut.load(data: FakeMidiData.midiDataTempo85)
        
        XCTAssertEqual(sut.duration.inSeconds, 50.82)
        XCTAssertEqual(sut.duration.inTicks.value, 34_560)
    }
    
}
