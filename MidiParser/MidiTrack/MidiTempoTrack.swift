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
    public private(set) var extendedTempos: [MidiExtendedTempoEvent] = []
    
    override init(musicTrack: MusicTrack) {
        super.init(musicTrack: musicTrack)
        reloadEvents()
    }
    
    private func reloadEvents() {
        timeSignatures = []
        extendedTempos = []
        
        iterator.seek(in: 0)
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
                case .extendedTempo:
                    let tempoEvent = MidiExtendedTempoEvent(eventInfo: eventInfo,
                                                            extendedTempoEvent: eventData.load(as: ExtendedTempoEvent.self))
                    extendedTempos.append(tempoEvent)
                default:
                    break
                }
            }
            
            if !iterator.hasNextEvent { break }
            iterator.nextEvent()
        }
    }
}
