//
//  MidiTempoTrack.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/10.
//  Copyright © 2017年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation

public final class MidiTempoTrack: MidiTrack {
    public private(set) var timeSignatures: [MidiTimeSignature] = []
    
    override init(musicTrack: MusicTrack) {
        super.init(musicTrack: musicTrack)
        reloadEvents()
    }
    
    private func reloadEvents() {
        timeSignatures = []
        
        let iterator = MidiEventIterator(track: musicTrack)
        while iterator.hasCurrentEvent {
            guard let eventInfo = iterator.getCurrentEvent(),
                let eventData = eventInfo.data else {
                fatalError("MidiTempoTrack error")
            }
            
            switch MidiEventType(eventInfo.type) {
            case .meta:
                var metaEvent = eventData.load(as: MIDIMetaEvent.self)
                var data: [Int] = []
                withUnsafeMutablePointer(to: &metaEvent.data) {
                    for i in 0 ..< Int(metaEvent.dataLength) {
                        data.append(Int($0.advanced(by: i).pointee))
                    }
                }
                switch MetaEventType(metaEvent.metaEventType) {
                case .timeSignature:
                    timeSignatures.append(MidiTimeSignature(eventInfo: eventInfo, data: data))
                default:
                    break
                }
            default:
                break
            }
            
            if !iterator.hasNextEvent { break }
            iterator.nextEvent()
        }
    }
}
