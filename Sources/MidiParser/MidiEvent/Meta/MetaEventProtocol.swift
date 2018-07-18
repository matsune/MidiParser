//
//  MetaEventProtocol.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2018/07/12.
//  Copyright © 2018 Yuma Matsune. All rights reserved.
//

import Foundation

protocol MetaEventProtocol: EventProtocol {
    var metaType: MetaEventType { get }
    var bytes: Bytes { get }
}

typealias MetaEventHeader = (metaType: UInt8, dataLength: UInt32)
