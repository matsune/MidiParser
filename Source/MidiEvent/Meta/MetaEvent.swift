//
//  MetaEvent.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2018/07/09.
//  Copyright © 2018 Yuma Matsune. All rights reserved.
//

import Foundation

typealias MetaEventHeader = (metaType: UInt8, dataLength: UInt32)

public struct MetaEvent {
    public var metaType: UInt8
    public var dataLength: UInt32
    public var data: [UInt8]
}
