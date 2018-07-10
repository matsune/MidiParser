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
    let _musicTrack: MusicTrack
    let iterator: MidiEventIterator
    
    public private(set) var timeSignatures: [MidiTimeSignature]
    
    public private(set) var extendedTempos: [MidiExtendedTempo]
    
    init(musicTrack: MusicTrack) {
        self._musicTrack = musicTrack
        let iterator = MidiEventIterator(track: musicTrack)
        self.iterator = iterator
        
        var timeSigs: [MidiTimeSignature] = []
        var extTempos: [MidiExtendedTempo] = []
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
                            timeSigs.append(timeSig)
                        default:
                            break
                        }
                    }
                case .extendedTempo:
                    let extendedTempo = MidiExtendedTempo(timeStamp: eventInfo.timeStamp, bpm: eventData.load(as: ExtendedTempoEvent.self).bpm)
                    extTempos.append(extendedTempo)
                default:
                    break
                }
            }
        }
        self.timeSignatures = timeSigs
        self.extendedTempos = extTempos
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
