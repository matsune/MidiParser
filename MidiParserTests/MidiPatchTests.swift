//
//  MidiPatchTests.swift
//  MidiParserTests
//
//  Created by Yuma Matsune on 2018/07/07.
//  Copyright © 2018 Yuma Matsune. All rights reserved.
//

@testable import MidiParser
import XCTest

extension GMPatch: EnumCollection {}

final class MidiPatchTests: XCTestCase {
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
            let patch = MidiPatch(program: $0)
            XCTAssertEqual(patch?.patch, allValues[$0])
            XCTAssertEqual(patch?.family, PatchFamily.piano)
        }
    }
    
    func testPercussion() {
        (8 ... 15).forEach {
            let patch = MidiPatch(program: $0)
            XCTAssertEqual(patch?.patch, allValues[$0])
            XCTAssertEqual(patch?.family, PatchFamily.percussion)
        }
    }
    
    func testOrgan() {
        (16 ... 23).forEach {
            let patch = MidiPatch(program: $0)
            XCTAssertEqual(patch?.patch, allValues[$0])
            XCTAssertEqual(patch?.family, PatchFamily.organ)
        }
    }
    
    func testGuitar() {
        (24 ... 31).forEach {
            let patch = MidiPatch(program: $0)
            XCTAssertEqual(patch?.patch, allValues[$0])
            XCTAssertEqual(patch?.family, PatchFamily.guitar)
        }
    }
    
    func testBass() {
        (32 ... 39).forEach {
            let patch = MidiPatch(program: $0)
            XCTAssertEqual(patch?.patch, allValues[$0])
            XCTAssertEqual(patch?.family, PatchFamily.bass)
        }
    }
    
    func testStrings() {
        (40 ... 47).forEach {
            let patch = MidiPatch(program: $0)
            XCTAssertEqual(patch?.patch, allValues[$0])
            XCTAssertEqual(patch?.family, PatchFamily.strings)
        }
    }
    
    func testEnsemble() {
        (48 ... 55).forEach {
            let patch = MidiPatch(program: $0)
            XCTAssertEqual(patch?.patch, allValues[$0])
            XCTAssertEqual(patch?.family, PatchFamily.ensemble)
        }
    }
    
    func testBrass() {
        (56 ... 63).forEach {
            let patch = MidiPatch(program: $0)
            XCTAssertEqual(patch?.patch, allValues[$0])
            XCTAssertEqual(patch?.family, PatchFamily.brass)
        }
    }
    
    func testReed() {
        (64 ... 71).forEach {
            let patch = MidiPatch(program: $0)
            XCTAssertEqual(patch?.patch, allValues[$0])
            XCTAssertEqual(patch?.family, PatchFamily.reed)
        }
    }
    
    func testPipe() {
        (72 ... 79).forEach {
            let patch = MidiPatch(program: $0)
            XCTAssertEqual(patch?.patch, allValues[$0])
            XCTAssertEqual(patch?.family, PatchFamily.pipe)
        }
    }
    
    func testSynthLead() {
        (80 ... 87).forEach {
            let patch = MidiPatch(program: $0)
            XCTAssertEqual(patch?.patch, allValues[$0])
            XCTAssertEqual(patch?.family, PatchFamily.synthLead)
        }
    }
    
    func testSynthPad() {
        (88 ... 95).forEach {
            let patch = MidiPatch(program: $0)
            XCTAssertEqual(patch?.patch, allValues[$0])
            XCTAssertEqual(patch?.family, PatchFamily.synthPad)
        }
    }
    
    func testSynthEffects() {
        (96 ... 103).forEach {
            let patch = MidiPatch(program: $0)
            XCTAssertEqual(patch?.patch, allValues[$0])
            XCTAssertEqual(patch?.family, PatchFamily.synthEffects)
        }
    }
    
    func testEthnic() {
        (104 ... 111).forEach {
            let patch = MidiPatch(program: $0)
            XCTAssertEqual(patch?.patch, allValues[$0])
            XCTAssertEqual(patch?.family, PatchFamily.ethnic)
        }
    }
    
    func testPercussive() {
        (112 ... 119).forEach {
            let patch = MidiPatch(program: $0)
            XCTAssertEqual(patch?.patch, allValues[$0])
            XCTAssertEqual(patch?.family, PatchFamily.percussive)
        }
    }
    
    func testSoundEffects() {
        (120 ... 127).forEach {
            let patch = MidiPatch(program: $0)
            XCTAssertEqual(patch?.patch, allValues[$0])
            XCTAssertEqual(patch?.family, PatchFamily.soundEffects)
        }
    }
    
    func testUnknown() {
        XCTAssertNil(MidiPatch(program: -1))
        XCTAssertNil(MidiPatch(program: 128))
    }
}
