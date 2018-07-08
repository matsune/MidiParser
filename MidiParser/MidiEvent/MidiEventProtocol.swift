//
//  MidiEventProtocol.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2018/07/08.
//  Copyright © 2018 Yuma Matsune. All rights reserved.
//

import AudioToolbox
import Foundation

protocol MidiEventProtocol {
    var timeStamp: MusicTimeStamp { get }
}
