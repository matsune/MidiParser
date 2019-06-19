//
//  ByteTests.swift
//  MidiParser iOSTests
//
//  Created by Vladimir Vybornov on 6/19/19.
//  Copyright © 2019 Yuma Matsune. All rights reserved.
//

import XCTest
@testable import MidiParser

final class ByteDWordTests: XCTestCase {

    func testWordGetVal_ReturnsDecimal() {
        XCTAssertEqual(Word(byte1: 0, byte2: 0).val, 0)
        XCTAssertEqual(Word(byte1: 0, byte2: 1).val, 1)
        XCTAssertEqual(Word(byte1: 0, byte2: 2).val, 2)
        
        XCTAssertEqual(Word(byte1: 1, byte2: 0).val, 16)
        XCTAssertEqual(Word(byte1: 1, byte2: 1).val, 17)
        XCTAssertEqual(Word(byte1: 1, byte2: 2).val, 18)
        
        XCTAssertEqual(Word(byte1: 10, byte2: 0).val, 160)
        
        XCTAssertEqual(Word(byte1: 11, byte2: 0).val, 176)
    }
    
    func testWordGetDecimal_ReturnsValue() {
        XCTAssertEqual(Word(byte1: 0, byte2: 0).decimal, 0)
        XCTAssertEqual(Word(byte1: 0, byte2: 1).decimal, 1)
        XCTAssertEqual(Word(byte1: 0, byte2: 2).decimal, 2)
        
        XCTAssertEqual(Word(byte1: 1, byte2: 0).decimal, 16)
        XCTAssertEqual(Word(byte1: 1, byte2: 1).decimal, 17)
        XCTAssertEqual(Word(byte1: 1, byte2: 2).decimal, 18)
        
        XCTAssertEqual(Word(byte1: 10, byte2: 0).decimal, 160)
        XCTAssertEqual(Word(byte1: 11, byte2: 0).decimal, 176)
    }
    
}

extension ByteDWordTests {
    
    func testDWordGetDecimal_ReturnsDecimal() {
        XCTAssertEqual(DWord(byte1: 0, byte2: 0, byte3: 0, byte4: 0).decimal, 0)
        XCTAssertEqual(DWord(byte1: 0, byte2: 0, byte3: 0, byte4: 1).decimal, 1)
        XCTAssertEqual(DWord(byte1: 0, byte2: 0, byte3: 0, byte4: 2).decimal, 2)
        
        XCTAssertEqual(DWord(byte1: 0, byte2: 0, byte3: 1, byte4: 0).decimal, 16)
        XCTAssertEqual(DWord(byte1: 0, byte2: 0, byte3: 1, byte4: 1).decimal, 17)
        XCTAssertEqual(DWord(byte1: 0, byte2: 0, byte3: 1, byte4: 2).decimal, 18)
        
        XCTAssertEqual(DWord(byte1: 0, byte2: 1, byte3: 0, byte4: 0).decimal, 256)
        XCTAssertEqual(DWord(byte1: 0, byte2: 1, byte3: 0, byte4: 1).decimal, 257)
        XCTAssertEqual(DWord(byte1: 0, byte2: 1, byte3: 1, byte4: 0).decimal, 272)
        XCTAssertEqual(DWord(byte1: 0, byte2: 1, byte3: 1, byte4: 2).decimal, 274)
        
        XCTAssertEqual(DWord(byte1: 1, byte2: 0, byte3: 0, byte4: 0).decimal, 4096)
        XCTAssertEqual(DWord(byte1: 1, byte2: 0, byte3: 0, byte4: 1).decimal, 4097)
        XCTAssertEqual(DWord(byte1: 1, byte2: 0, byte3: 1, byte4: 0).decimal, 4112)
        XCTAssertEqual(DWord(byte1: 1, byte2: 1, byte3: 0, byte4: 0).decimal, 4352)
        XCTAssertEqual(DWord(byte1: 1, byte2: 1, byte3: 1, byte4: 0).decimal, 4368)
        XCTAssertEqual(DWord(byte1: 1, byte2: 1, byte3: 1, byte4: 1).decimal, 4369)
    }
    
}

extension ByteDWordTests {
    
    func testByteCollectionGetString_ReturnsString() {
        XCTAssertEqual([Byte(0), Byte(1), Byte(2), Byte(3)].string, "\0\u{01}\u{02}\u{03}")
    }
    
}
