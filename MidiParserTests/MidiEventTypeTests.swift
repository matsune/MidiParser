//
//  MidiEventTypeTests.swift
//  MidiParserTests
//
//  Created by Yuma Matsune on 2018/07/07.
//  Copyright © 2018 Yuma Matsune. All rights reserved.
//

import AudioToolbox
@testable import MidiParser
import XCTest

extension MidiEventType: EnumCollection {}

final class MidiEventTypeTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testMidiEventType() {
        let values = [
            kMusicEventType_NULL,
            kMusicEventType_ExtendedNote,
            kMusicEventType_ExtendedTempo,
            kMusicEventType_User,
            kMusicEventType_Meta,
            kMusicEventType_MIDINoteMessage,
            kMusicEventType_MIDIChannelMessage,
            kMusicEventType_MIDIRawData,
            kMusicEventType_Parameter,
            kMusicEventType_AUPreset
        ]
        let expects = MidiEventType.allValues
        assert(values.count == expects.count)
        
        for i in 0 ..< values.count {
            XCTAssertEqual(MidiEventType(values[i]), expects[i])
        }
        
        precondition(!values.contains(1000))
        XCTAssertNil(MidiEventType(1000))
    }
}
