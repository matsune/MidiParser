//
//  PatchTests.swift
//  MidiParserTests
//
//  Created by Yuma Matsune on 2018/07/07.
//  Copyright © 2018 Yuma Matsune. All rights reserved.
//

@testable import MidiParser
import XCTest

extension GMPatch: EnumCollection {}

final class PatchTests: XCTestCase {
    private var allValues: [GMPatch]!
    
    override func setUp() {
        super.setUp()
        allValues = GMPatch.allValues
        assert(allValues.count == 128)
    }
    
    override func tearDown() {
        allValues = nil
        super.tearDown()
    }
    
    func testPianoFamily() {
        (0 ... 7).forEach {
            let patch = GMPatch(rawValue: UInt8($0))
            XCTAssertEqual(patch, allValues[$0])
            XCTAssertEqual(PatchFamily(rawValue: UInt8($0) / 8), .piano)
        }
    }
    
    func testPercussion() {
        (8 ... 15).forEach {
            let patch = GMPatch(rawValue: UInt8($0))
            XCTAssertEqual(patch, allValues[$0])
        }
    }
    
    func testOrgan() {
        (16 ... 23).forEach {
            let patch = GMPatch(rawValue: UInt8($0))
            XCTAssertEqual(patch, allValues[$0])
            XCTAssertEqual(PatchFamily(rawValue: UInt8($0) / 8), PatchFamily.organ)
        }
    }
    
    func testGuitar() {
        (24 ... 31).forEach {
            let patch = GMPatch(rawValue: UInt8($0))
            XCTAssertEqual(patch, allValues[$0])
            XCTAssertEqual(PatchFamily(rawValue: UInt8($0) / 8), PatchFamily.guitar)
        }
    }
    
    func testBass() {
        (32 ... 39).forEach {
            let patch = GMPatch(rawValue: UInt8($0))
            XCTAssertEqual(patch, allValues[$0])
            XCTAssertEqual(PatchFamily(rawValue: UInt8($0) / 8), PatchFamily.bass)
        }
    }
    
    func testStrings() {
        (40 ... 47).forEach {
            let patch = GMPatch(rawValue: UInt8($0))
            XCTAssertEqual(patch, allValues[$0])
            XCTAssertEqual(PatchFamily(rawValue: UInt8($0) / 8), PatchFamily.strings)
        }
    }
    
    func testEnsemble() {
        (48 ... 55).forEach {
            let patch = GMPatch(rawValue: UInt8($0))
            XCTAssertEqual(patch, allValues[$0])
            XCTAssertEqual(PatchFamily(rawValue: UInt8($0) / 8), PatchFamily.ensemble)
        }
    }
    
    func testBrass() {
        (56 ... 63).forEach {
            let patch = GMPatch(rawValue: UInt8($0))
            XCTAssertEqual(patch, allValues[$0])
            XCTAssertEqual(PatchFamily(rawValue: UInt8($0) / 8), PatchFamily.brass)
        }
    }
    
    func testReed() {
        (64 ... 71).forEach {
            let patch = GMPatch(rawValue: UInt8($0))
            XCTAssertEqual(patch, allValues[$0])
            XCTAssertEqual(PatchFamily(rawValue: UInt8($0) / 8), PatchFamily.reed)
        }
    }
    
    func testPipe() {
        (72 ... 79).forEach {
            let patch = GMPatch(rawValue: UInt8($0))
            XCTAssertEqual(patch, allValues[$0])
            XCTAssertEqual(PatchFamily(rawValue: UInt8($0) / 8), PatchFamily.pipe)
        }
    }
    
    func testSynthLead() {
        (80 ... 87).forEach {
            let patch = GMPatch(rawValue: UInt8($0))
            XCTAssertEqual(patch, allValues[$0])
            XCTAssertEqual(PatchFamily(rawValue: UInt8($0) / 8), PatchFamily.synthLead)
        }
    }
    
    func testSynthPad() {
        (88 ... 95).forEach {
            let patch = GMPatch(rawValue: UInt8($0))
            XCTAssertEqual(patch, allValues[$0])
            XCTAssertEqual(PatchFamily(rawValue: UInt8($0) / 8), PatchFamily.synthPad)
        }
    }
    
    func testSynthEffects() {
        (96 ... 103).forEach {
            let patch = GMPatch(rawValue: UInt8($0))
            XCTAssertEqual(patch, allValues[$0])
            XCTAssertEqual(PatchFamily(rawValue: UInt8($0) / 8), PatchFamily.synthEffects)
        }
    }
    
    func testEthnic() {
        (104 ... 111).forEach {
            let patch = GMPatch(rawValue: UInt8($0))
            XCTAssertEqual(patch, allValues[$0])
            XCTAssertEqual(PatchFamily(rawValue: UInt8($0) / 8), PatchFamily.ethnic)
        }
    }
    
    func testPercussive() {
        (112 ... 119).forEach {
            let patch = GMPatch(rawValue: UInt8($0))
            XCTAssertEqual(patch, allValues[$0])
            XCTAssertEqual(PatchFamily(rawValue: UInt8($0) / 8), PatchFamily.percussive)
        }
    }
    
    func testSoundEffects() {
        (120 ... 127).forEach {
            let patch = GMPatch(rawValue: UInt8($0))
            XCTAssertEqual(patch, allValues[$0])
            XCTAssertEqual(PatchFamily(rawValue: UInt8($0) / 8), PatchFamily.soundEffects)
        }
    }
}
