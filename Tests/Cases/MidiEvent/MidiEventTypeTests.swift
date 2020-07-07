//
//  MidiEventTypeTests.swift
//  MidiParser iOSTests
//
//  Created by Vladimir Vybornov on 6/21/19.
//  Copyright © 2019 Yuma Matsune. All rights reserved.
//
import AudioToolbox
import XCTest
@testable import MidiParser

final class MidiEventTypeTests: XCTestCase {
   
    func testEventType_GetDebugDescription_ReturnMusicEventTypeString() {
        XCTAssertEqual(MidiEventType.null.debugDescription, "MidiEventType.null")
        XCTAssertEqual(MidiEventType.extendedNote.debugDescription, "MidiEventType.extendedNote")
        XCTAssertEqual(MidiEventType.extendedTempo.debugDescription, "MidiEventType.extendedTempo")
        XCTAssertEqual(MidiEventType.user.debugDescription, "MidiEventType.user")
        XCTAssertEqual(MidiEventType.meta.debugDescription, "MidiEventType.meta")
        XCTAssertEqual(MidiEventType.noteMessage.debugDescription, "MidiEventType.midiNoteMessage")
        XCTAssertEqual(MidiEventType.channelMessage.debugDescription, "MidiEventType.midiChannelMessage")
        XCTAssertEqual(MidiEventType.rawData.debugDescription, "MidiEventType.midiRawData")
        XCTAssertEqual(MidiEventType.parameter.debugDescription, "MidiEventType.parameter")
        XCTAssertEqual(MidiEventType.auPreset.debugDescription, "MidiEventType.auPreset")
    }

    func testMetaEventType_AllCases_ReturnCount() {
        let musicEventTypeCases = [kMusicEventType_NULL, kMusicEventType_ExtendedNote, kMusicEventType_ExtendedTempo, kMusicEventType_User, kMusicEventType_Meta, kMusicEventType_MIDINoteMessage, kMusicEventType_MIDIChannelMessage, kMusicEventType_MIDIRawData, kMusicEventType_Parameter, kMusicEventType_AUPreset
        ]
        let sut = MidiEventType.allCases
        XCTAssertEqual(sut.count, 10)
        
        for (i, type) in musicEventTypeCases.enumerated() {
            XCTAssertEqual(MidiEventType(type), sut[i])
        }
    }
    
    func testInitMusicEventType_WithValidType_ReturnsType() {
        XCTAssertEqual(MidiEventType(MusicEventType(kMusicEventType_NULL)), .null)
        XCTAssertEqual(MidiEventType(MusicEventType(kMusicEventType_ExtendedNote)), MidiEventType.extendedNote)
        XCTAssertEqual(MidiEventType(MusicEventType(kMusicEventType_ExtendedTempo)), MidiEventType.extendedTempo)
        XCTAssertEqual(MidiEventType(MusicEventType(kMusicEventType_User)), MidiEventType.user)
        XCTAssertEqual(MidiEventType(MusicEventType(kMusicEventType_Meta)), MidiEventType.meta)
        XCTAssertEqual(MidiEventType(MusicEventType(kMusicEventType_MIDINoteMessage)), MidiEventType.noteMessage)
        XCTAssertEqual(MidiEventType(MusicEventType(kMusicEventType_MIDIChannelMessage)), MidiEventType.channelMessage)
        XCTAssertEqual(MidiEventType(MusicEventType(kMusicEventType_MIDIRawData)), MidiEventType.rawData)
        XCTAssertEqual(MidiEventType(MusicEventType(kMusicEventType_Parameter)), MidiEventType.parameter)
        XCTAssertEqual(MidiEventType(MusicEventType(kMusicEventType_AUPreset)), MidiEventType.auPreset)
    }
    
    func testInitMusicEventType_WithInValidType_ReturnsNil() {
        XCTAssertNil(MidiEventType(MusicEventType(kMusicEventType_NULL + 100)))
        XCTAssertNil(MidiEventType(MusicEventType(kMusicEventType_ExtendedNote + 100)))
        XCTAssertNil(MidiEventType(MusicEventType(kMusicEventType_ExtendedTempo + 100)))
        XCTAssertNil(MidiEventType(MusicEventType(kMusicEventType_User + 100)))
    }
    
}
