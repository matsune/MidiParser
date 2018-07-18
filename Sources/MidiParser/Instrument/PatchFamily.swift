//
//  InstrumentFamily.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2018/02/03.
//  Copyright © 2018年 matsune. All rights reserved.
//

import Foundation

// each family has 8 patches
public enum PatchFamily: UInt8 {
    case piano
    case percussion
    case organ
    case guitar
    case bass
    case strings
    case ensemble
    case brass
    case reed
    case pipe
    case synthLead
    case synthPad
    case synthEffects
    case ethnic
    case percussive
    case soundEffects
}
