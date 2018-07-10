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
        
        iterator.enumerate { eventInfo in
            guard let eventInfo = eventInfo,
                let eventData = eventInfo.data else {
                fatalError("MidiTempoTrack error")
            }
            
            if let eventType = MidiEventType(eventInfo.type) {
                switch eventType {
                case .meta:
                    let header = eventData.assumingMemoryBound(to: MetaEventHeader.self).pointee
                    var data: [UInt8] = []
                    for i in 0 ..< Int(header.dataLength) {
                        data.append(eventData.advanced(by: MemoryLayout<MetaEventHeader>.size).advanced(by: i).load(as: UInt8.self))
                    }
                    
                    if let metaType = MetaEventType(decimal: header.metaType) {
                        switch metaType {
                        case .timeSignature:
                            let numerator = Int(data[0])
                            let decimal = pow(Decimal(2), Int(data[1]))
                            let num = NSDecimalNumber(decimal: decimal)
                            let denominator = Int(truncating: num)
                            timeSignatures.append(MidiTimeSignature(timeStamp: eventInfo.timeStamp, numerator: numerator, denominator: denominator, cc: Int(data[2]), bb: Int(data[3])))
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
}
