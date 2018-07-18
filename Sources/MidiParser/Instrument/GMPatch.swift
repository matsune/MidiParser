//
//  GMPatch.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2018/02/03.
//  Copyright © 2018年 matsune. All rights reserved.
//

import Foundation

// General MIDI Instrument Patch Map defines 128 instruments with program number 0 to 127.
public enum GMPatch: UInt8 {
    // 0-7 PIANO
    case acousticGrand
    case brightAcoustic
    case electricGrand
    case honkyTonk
    case electricPiano1
    case electricPiano2
    case harpsichord
    case clavinet
    // 8-15 CHROMATIC PERCUSSION
    case celesta
    case glockenspiel
    case musicBox
    case vibraphone
    case marimba
    case xylophone
    case tubularBells
    case dulcimer
    // 16-23 ORGAN
    case drawbarOrgan
    case percussiveOrgan
    case rockOrgan
    case churchOrgan
    case reedOrgan
    case accordion
    case harmonica
    case rangoAccordian
    // 24-31 GUITAR
    case acousticGuitarNylon
    case acousticGuitarSteel
    case electricGuitarJazz
    case electricGuitarClean
    case electricGuitarMuted
    case overdrivenGuitar
    case distortionGuitar
    case guitarHarmonics
    // 32-39 BASS
    case acousticBass
    case electricBassFinger
    case electricBassPick
    case fretlessBass
    case slapBass1
    case slapBass2
    case synthBass1
    case synthBass2
    // 40-47 STRINGS
    case violin
    case viola
    case cello
    case contrabass
    case tremoloStrings
    case pizzicatoStrings
    case orchestralStrings
    case timpani
    // 48-55 ENSEMBLE
    case stringEnsemble1
    case stringEnsemble2
    case synthStrings1
    case synthStrings2
    case choirAahs
    case voiceOohs
    case synthVoice
    case orchestraHit
    // 56-63 BRASS
    case trumpet
    case trombone
    case tuba
    case mutedTrumpet
    case frenchHorn
    case brassSection
    case synthBrass1
    case synthBrass2
    // 64-71 REED
    case sopranoSax
    case altoSax
    case tenorSax
    case baritoneSax
    case oboe
    case englishHorn
    case bassoon
    case clarinet
    // 72-79 PIPE
    case piccolo
    case flute
    case recorder
    case panFlute
    case blownBottle
    case skakuhachi
    case whistle
    case ocarina
    // 80-87 SYNTH LEAD
    case lead1square
    case lead2sawtooth
    case lead3calliope
    case lead4chiff
    case lead5charang
    case lead6voice
    case lead7fifths
    case lead8basslead
    // 88-95 SYNTH PAD
    case pad1newage
    case pad2warm
    case pad3polysynth
    case pad4choir
    case pad5bowed
    case pad6metallic
    case pad7halo
    case pad8sweep
    // 96-103 SYNTH EFFECTS
    case FX1Rain
    case FX2Soundtrack
    case FX3Crystal
    case FX4Atmosphere
    case FX5Brightness
    case FX6Goblins
    case FX7Echoes
    case FX8Scifi
    // 104-111 ETHNIC
    case sitar
    case banjo
    case shamisen
    case koto
    case kalimba
    case bagpipe
    case fiddle
    case shanai
    // 112-119 PERCUSSIVE
    case tinkleBell
    case agogo
    case steelDrums
    case woodblock
    case taikoDrum
    case melodicTom
    case synthDrum
    case reverseCymbal
    // 120-127 SOUND EFFECTS
    case guitarFretNoise
    case breathNoise
    case seashore
    case birdTweet
    case telephoneRing
    case helicopter
    case applause
    case gunshot
}
