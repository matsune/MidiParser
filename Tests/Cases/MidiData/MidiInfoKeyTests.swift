//
//  MidiInfoKeyTests.swift
//  MidiParser iOSTests
//
//  Created by Vladimir Vybornov on 6/21/19.
//  Copyright © 2019 Yuma Matsune. All rights reserved.
//

import AudioToolbox
import XCTest
@testable import MidiParser

final class MidiInfoKeyTests: XCTestCase {
    
    func testInitMidiInfoKey_Val_ReturnType() {
        XCTAssertEqual(MidiInfoKey(val: kAFInfoDictionary_Album), .album)
        XCTAssertEqual(MidiInfoKey(val: kAFInfoDictionary_ApproximateDurationInSeconds), .approximateDurationInSeconds)
        XCTAssertEqual(MidiInfoKey(val: kAFInfoDictionary_Artist), .artist)
        XCTAssertEqual(MidiInfoKey(val: kAFInfoDictionary_ChannelLayout), .channelLayout)
        XCTAssertEqual(MidiInfoKey(val: kAFInfoDictionary_Comments), .comments)
        XCTAssertEqual(MidiInfoKey(val: kAFInfoDictionary_Composer), .composer)
        XCTAssertEqual(MidiInfoKey(val: kAFInfoDictionary_Copyright), .copyright)
        XCTAssertEqual(MidiInfoKey(val: kAFInfoDictionary_EncodingApplication), .encodingApplication)
        XCTAssertEqual(MidiInfoKey(val: kAFInfoDictionary_Genre), .genre)
        XCTAssertEqual(MidiInfoKey(val: kAFInfoDictionary_ISRC), .isrc)
        XCTAssertEqual(MidiInfoKey(val: kAFInfoDictionary_KeySignature), .keySignature)
        XCTAssertEqual(MidiInfoKey(val: kAFInfoDictionary_Lyricist), .lyricist)
        XCTAssertEqual(MidiInfoKey(val: kAFInfoDictionary_NominalBitRate), .nominalBitRate)
        XCTAssertEqual(MidiInfoKey(val: kAFInfoDictionary_RecordedDate), .recordedDate)
        XCTAssertEqual(MidiInfoKey(val: kAFInfoDictionary_SourceBitDepth), .sourceBitDepth)
        XCTAssertEqual(MidiInfoKey(val: kAFInfoDictionary_SourceEncoder), .sourceEncoder)
        XCTAssertEqual(MidiInfoKey(val: kAFInfoDictionary_SubTitle), .subTitle)
        XCTAssertEqual(MidiInfoKey(val: kAFInfoDictionary_Tempo), .tempo)
        XCTAssertEqual(MidiInfoKey(val: kAFInfoDictionary_TimeSignature), .timeSignature)
        XCTAssertEqual(MidiInfoKey(val: kAFInfoDictionary_Title), .title)
        XCTAssertEqual(MidiInfoKey(val: kAFInfoDictionary_TrackNumber), .trackNumber)
        XCTAssertEqual(MidiInfoKey(val: kAFInfoDictionary_Year), .year)
    }
}
