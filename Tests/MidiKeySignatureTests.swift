//
//  MidiKeySignatureTests.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2018/07/10.
//  Copyright © 2018 Yuma Matsune. All rights reserved.
//

@testable import MidiParser
import XCTest

class MidiKeySignatureTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMajorKey() {
        let sfValues: [UInt8] = [0, 1, 2, 3, 4, 5, 6, 7, 255, 254, 253, 252, 251, 250, 249]
        let expects: [MajorKey] = [.C, .G, .D, .A, .E, .B, .Fsharp, .Csharp, .F, .Bflat, .Eflat, .Aflat, .Dflat, .Gflat, .Cflat]
        assert(sfValues.count == expects.count)
        
        for i in 0 ..< sfValues.count {
            XCTAssertEqual(MidiKeySignature(timeStamp: 0, sf: sfValues[i], isMajor: true).keySig, KeySignature.major(expects[i]))
        }
    }
    
    func testMinorKey() {
        let sfValues: [UInt8] = [0, 1, 2, 3, 4, 5, 6, 7, 255, 254, 253, 252, 251, 250, 249]
        let expects: [MinorKey] = [.A, .E, .B, .Fsharp, .Csharp, .Gsharp, .Dsharp, .Asharp, .D, .G, .C, .F, .Bflat, .Eflat, .Aflat]
        assert(sfValues.count == expects.count)
        
        for i in 0 ..< sfValues.count {
            XCTAssertEqual(MidiKeySignature(timeStamp: 0, sf: sfValues[i], isMajor: false).keySig, KeySignature.minor(expects[i]))
        }
    }
}
