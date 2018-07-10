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
    
    public private(set) var extendedTempos: [MidiExtendedTempo] = []
    
    override init(musicTrack: MusicTrack) {
        super.init(musicTrack: musicTrack)
        reloadEvents()
    }
    
    private func reloadEvents() {
        timeSignatures = []
        extendedTempos = []
        
        iterator.enumerate { eventInfo, _ in
            guard let eventData = eventInfo.data else {
                fatalError("MidiTempoTrack error")
            }
            
            if let eventType = MidiEventType(eventInfo.type) {
                switch eventType {
                case .meta:
                    let header = eventData.assumingMemoryBound(to: MetaEventHeader.self).pointee
                    var data: Bytes = []
                    for i in 0 ..< Int(header.dataLength) {
                        data.append(eventData.advanced(by: MemoryLayout<MetaEventHeader>.size).advanced(by: i).load(as: UInt8.self))
                    }
                    
                    if let metaType = MetaEventType(byte: header.metaType) {
                        switch metaType {
                        case .timeSignature:
                            let timeSig = MidiTimeSignature(timeStamp: eventInfo.timeStamp, numerator: data[0], denominator: data[1], cc: data[2], bb: data[3])
                            timeSignatures.append(timeSig)
                        default:
                            break
                        }
                    }
                case .extendedTempo:
                    let extendedTempo = MidiExtendedTempo(timeStamp: eventInfo.timeStamp, bpm: eventData.load(as: ExtendedTempoEvent.self).bpm)
                    extendedTempos.append(extendedTempo)
                default:
                    break
                }
            }
        }
    }
    
    public func setTimeSignatures(_ timeSignatures: [MidiTimeSignature]) {
        var count = 0
        iterator.enumerate { (info, finished) in
            if let metaEvent = info.data?.assumingMemoryBound(to: MIDIMetaEvent.self).pointee,
                MetaEventType(byte: metaEvent.metaEventType) == .timeSignature {
                iterator.deleteEvent()
                count += 1
                finished = count >= self.timeSignatures.count
            }
        }
        timeSignatures.forEach {
            add(metaEvent: $0)
        }
        self.timeSignatures = timeSignatures
    }
    
    public func setExtendedTempos(_ extendedTempos: [MidiExtendedTempo]) {
        var count = 0
        iterator.enumerate { (info, finished) in
            if let _ = info.data?.assumingMemoryBound(to: ExtendedTempoEvent.self).pointee {
                iterator.deleteEvent()
                count += 1
                finished = count >= self.extendedTempos.count
            }
        }
        extendedTempos.forEach {
            add(extendedTempo: $0)
        }
        self.extendedTempos = extendedTempos
    }
}
