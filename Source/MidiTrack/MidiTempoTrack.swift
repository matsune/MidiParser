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
    
    public var timeSignatures: [MidiTimeSignature] {
        didSet {
            var count = 0
            iterator.enumerate { (info, finished) in
                if let metaEvent = info.data?.assumingMemoryBound(to: MIDIMetaEvent.self).pointee,
                    MetaEventType(byte: metaEvent.metaEventType) == .timeSignature {
                    iterator.deleteEvent()
                    count += 1
                    finished = count >= oldValue.count
                }
            }
            timeSignatures.forEach {
                add(metaEvent: $0)
            }
        }
    }
    
    public var extendedTempos: [MidiExtendedTempo] {
        didSet {
            var count = 0
            iterator.enumerate { (info, finished) in
                if let _ = info.data?.assumingMemoryBound(to: ExtendedTempoEvent.self).pointee {
                    iterator.deleteEvent()
                    count += 1
                    finished = count >= oldValue.count
                }
            }
            extendedTempos.forEach {
                add(extendedTempo: $0)
            }
        }
    }
    
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
}
