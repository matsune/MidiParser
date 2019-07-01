//
//  TicksTests.swift
//  MidiParser iOSTests
//
//  Created by Vladimir Vybornov on 6/22/19.
//  Copyright © 2019 Yuma Matsune. All rights reserved.
//

import XCTest
@testable import MidiParser

final class TicksTests: XCTestCase {

    func testTicksPerBeat_ReturnsRegular() {
        XCTAssertEqual(TicksPerBeat.regular.value, 480)
    }
    
    func testInitTicksPerBeat_ReturnsValue() {
        XCTAssertEqual(TicksPerBeat(300).value, 300)
        XCTAssertEqual(TicksPerBeat(200).value, 200)
    }
    
    func testBeatsPerMinute_ReturnsRegular() {
        XCTAssertEqual(BeatsPerMinute.regular.value, 60)
    }
    
    func testInitBeatsPerMinute_ReturnsValue() {
        XCTAssertEqual(BeatsPerMinute(300).value, 300)
        XCTAssertEqual(BeatsPerMinute(200).value, 200)
    }
}

//MARK: - Ticks
extension TicksTests {
    
    func testInitTicks_ReturnsValue() {
        XCTAssertEqual(Ticks(1_920).value, 1_920)
        XCTAssertEqual(Ticks(2_400).value, 2_400)
    }
    
    func testInitTicks_ReturnsMs() {
        XCTAssertEqual(Ticks(1_920).toMs(forBeatsPerMinute: BeatsPerMinute(45)).value, 5_333)
        XCTAssertEqual(Ticks(1_920).toMs(forBeatsPerMinute: BeatsPerMinute(60)).value, 4_000)
        XCTAssertEqual(Ticks(1_920).toMs(forBeatsPerMinute: BeatsPerMinute(85)).value, 2_823)
    }
}

//MARK: - Ticks overloading +
extension TicksTests {
    
    func testTicks_GetPlus_ReturnsValueSum () {
        XCTAssertEqual((Ticks(1) + Ticks(2)).value, 3)
        XCTAssertEqual((Ticks(1_920) + Ticks(1_920)).value, 3_840)
        XCTAssertEqual((Ticks(1_920) + Ticks(2_345)).value, 4_265)
    }
    
}


//MARK: - Milliseconds
extension TicksTests {
    
    func testMilliseconds_ReturnsValues() {
        XCTAssertEqual(Milliseconds.inMinute, 60_000)
        XCTAssertEqual(Milliseconds.inSecond, 1_000)
        
        XCTAssertEqual(Milliseconds(1_000).value, 1_000)
        XCTAssertEqual(Milliseconds(2_500).value, 2_500)
    }
    
    func testInitDouble_ReturnsValues() {
        XCTAssertEqual(Milliseconds(4.0).value, 4_000)
        XCTAssertEqual(Milliseconds(4.5).value, 4_500)
        
        XCTAssertEqual(Milliseconds(4.512).value, 4_512)
        XCTAssertEqual(Milliseconds(4.5125).value, 4_513)
        XCTAssertEqual(Milliseconds(4.5126).value, 4_513)
    }
    
    func testMilliseconds_ToTicks_ReturnsValue() {
        XCTAssertEqual(Milliseconds(5_333).toTicks(forBeatsPerMinute: BeatsPerMinute(45)).value, 1_920)
        XCTAssertEqual(Milliseconds(4_000).toTicks(forBeatsPerMinute: BeatsPerMinute(60)).value, 1_920)
        XCTAssertEqual(Milliseconds(2_823).toTicks(forBeatsPerMinute: BeatsPerMinute(85)).value, 1_920)
        
        XCTAssertEqual(Milliseconds(4_000).toTicks().value, 1_920)
    }
    
    func testMilliseconds_ToSeconds_ReturnsValues() {
        XCTAssertEqual(Milliseconds(1_123).seconds, 1.123)
        XCTAssertEqual(Milliseconds(2_500).seconds, 2.5)
    }
}
