//
//  MidiMetaEvent.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2018/07/10.
//  Copyright © 2018 Yuma Matsune. All rights reserved.
//

import AudioToolbox
import Foundation

protocol MetaEventProtocol: EventProtocol {
    var metaType: MetaEventType { get }
    var bytes: Bytes { get }
}

struct MidiMetaEvent: MetaEventProtocol {
    let timeStamp: MusicTimeStamp
    let metaType: MetaEventType
    let bytes: Bytes
}
