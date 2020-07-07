//
//  MidiTimeTests.swift
//  MidiParser iOSTests
//
//  Created by Vladimir Vybornov on 7/1/19.
//  Copyright © 2019 Yuma Matsune. All rights reserved.
//

@testable import MidiParser
import XCTest

final class MidiTimeTests: XCTestCase {

    func testInit_ReturnsInstance() {
        let sut = MidiTime(inSeconds: 12.34, inTicks: Ticks(123))
        
        XCTAssertEqual(sut.inSeconds, 12.34)
        XCTAssertEqual(sut.inTicks.value, 123)
    }
    
    func testGetEmpty_ReturnsInstanceWithZeroValues() {
        let sut = MidiTime.empty
        
        XCTAssertEqual(sut.inSeconds, 0.0)
        XCTAssertEqual(sut.inTicks.value, 0)
    }
}
