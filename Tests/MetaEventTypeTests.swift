//
//  MetaEventTypeTests.swift
//  MidiParserTests
//
//  Created by Yuma Matsune on 2018/07/07.
//  Copyright © 2018 Yuma Matsune. All rights reserved.
//

@testable import MidiParser
import XCTest

extension MetaEventType: EnumCollection {}

final class MetaEventTypeTests: XCTestCase {
    var values: Bytes!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        values = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 32, 33, 47, 81, 84, 88, 89, 127]
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        values = nil
        super.tearDown()
    }
    
    func testMetaEventType() {
        let expects = MetaEventType.allValues
        
        for i in 0 ..< values.count {
            XCTAssertEqual(MetaEventType(byte: values[i]), expects[i])
        }
    }
    
    func testUnknownMetaEventType() {
        (0 ... 128)
            .filter { !values.contains($0) }
            .forEach {
                XCTAssertNil(MetaEventType(byte: $0))
            }
    }
}
