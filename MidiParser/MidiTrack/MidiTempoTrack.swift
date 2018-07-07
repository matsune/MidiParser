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
        
        let iterator = MidiEventIterator(track: _musicTrack)
        while iterator.hasCurrentEvent {
            guard let eventInfo = iterator.currentEvent,
                let eventData = eventInfo.data else {
                fatalError("MidiTempoTrack error")
            }
            
            if let eventType = MidiEventType(eventInfo.type) {
                switch eventType {
                case .meta:
                    var metaEvent = eventData.load(as: MIDIMetaEvent.self)
                    var data: [Int] = []
                    withUnsafeMutablePointer(to: &metaEvent.data) {
                        for i in 0 ..< Int(metaEvent.dataLength) {
                            data.append(Int($0.advanced(by: i).pointee))
                        }
                    }
                    if let metaType = MetaEventType(decimal: metaEvent.metaEventType) {
                        switch metaType {
                        case .timeSignature:
                            timeSignatures.append(MidiTimeSignature(eventInfo: eventInfo, data: data))
                        default:
                            break
                        }
                    }
                default:
                    break
                }
            }
            
            if !iterator.hasNextEvent { break }
            iterator.nextEvent()
        }
    }
}
