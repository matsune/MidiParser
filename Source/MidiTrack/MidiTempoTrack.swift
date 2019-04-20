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
    let iterator: EventIterator
    
    public var timeSignatures: [MidiTimeSignature] = [] {
        didSet {
            if isReload {
                return
            }
            
            var count = 0
            iterator.enumerate { info, finished, next in
                if let metaEvent: MIDIMetaEvent = bindEventData(info: info),
                    MetaEventType(byte: metaEvent.metaEventType) == .timeSignature {
                    iterator.deleteEvent()
                    next = false
                    count += 1
                }
                finished = count >= oldValue.count
            }
            timeSignatures.forEach {
                add(metaEvent: $0)
            }
        }
    }
    
    public var extendedTempos: [MidiExtendedTempo] = [] {
        didSet {
            if isReload {
                return
            }
            
            var count = 0
            iterator.enumerate { info, finished, next in
                if let _: ExtendedTempoEvent = bindEventData(info: info) {
                    iterator.deleteEvent()
                    next = false
                    count += 1
                }
                finished = count >= oldValue.count
            }
            extendedTempos.forEach {
                add(extendedTempo: $0)
            }
        }
    }
    
    init(musicTrack: MusicTrack) {
        _musicTrack = musicTrack
        iterator = EventIterator(track: musicTrack)
        reload()
    }
    
    private var isReload = false
    
    func reload() {
        isReload = true
        defer {
            isReload = false
        }
        
        timeSignatures.removeAll()
        extendedTempos.removeAll()
        
        iterator.enumerate { eventInfo, _, _ in
            guard let eventData = eventInfo.data,
                let eventType = MidiEventType(eventInfo.type) else {
                return
            }
            
            switch eventType {
            case .meta:
                let header = eventData.assumingMemoryBound(to: MetaEventHeader.self).pointee
                var data: Bytes = []
                for i in 0 ..< Int(header.dataLength) {
                    data.append(eventData
                        .advanced(by: MemoryLayout<MetaEventHeader>.size)
                        .advanced(by: i)
                        .load(as: UInt8.self))
                }
                
                guard let metaType = MetaEventType(byte: header.metaType) else {
                    return
                }
                
                switch metaType {
                case .timeSignature:
                    let timeSig = MidiTimeSignature(timeStamp: eventInfo.timeStamp,
                                                    numerator: data[0],
                                                    denominator: data[1],
                                                    cc: data[2],
                                                    bb: data[3])
                    timeSignatures.append(timeSig)
                default:
                    break
                }
            case .extendedTempo:
                let extendedTempo = MidiExtendedTempo(timeStamp: eventInfo.timeStamp,
                                                      bpm: eventData.load(as: ExtendedTempoEvent.self).bpm)
                extendedTempos.append(extendedTempo)
            default:
                break
            }
        }
    }
    
    public var timeResolution: Int16 {
        var data: Int16 = 0
        getProperty(.timeResolution, data: &data)
        return data
    }
}
