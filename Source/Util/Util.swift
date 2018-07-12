//
//  Util.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2018/01/17.
//  Copyright © 2018年 matsune. All rights reserved.
//

import Foundation

enum ErrorLevel {
    case fatal
    case log
    case ignore
}

@discardableResult
func check(_ status: OSStatus, label: String, level: ErrorLevel = .fatal) -> OSStatus {
    if status != noErr {
        let str = "\(label) error: \(status)"
        switch level {
        case .fatal:
            fatalError(str)
        case .log:
            print(str)
        case .ignore:
            break
        }
    }
    return status
}

func sizeof<T>(_ type: T.Type) -> UInt32 {
    return UInt32(MemoryLayout<T>.size)
}

extension UInt8 {
    var hexString: String {
        return String(self, radix: 16).uppercased()
    }
}

extension String.SubSequence {
    var number: UInt8? {
        return UInt8(self, radix: 16)
    }
}

func write(bytes: Bytes, to data: inout UInt8) {
    withUnsafeMutablePointer(to: &data) {
        for i in 0 ..< bytes.count {
            $0.advanced(by: i).pointee = bytes[i]
        }
    }
}
