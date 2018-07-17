# MidiParser
MidiParser is a wrapper library of AudioToolbox.framework about SMF(Standard Midi Files) that makes it easy to read/write midi files.

AudioToolbox framework provides many useful APIs for MIDI, but they are not Swifty styles (bridging with C pointers, explicit deallocation, etc).
MidiParser wraps them and make more Swifty to access properties.

- no need to care about deallocating
- no need `UnsafePointers`, `CF`types
- use `Enum` for constants

# Usage
## Read
### Import *.mid file
<img src="https://user-images.githubusercontent.com/12775019/42793905-40618dd2-89b7-11e8-934a-4109390c421f.png">

```swift

import MidiParser

let midi = MidiData()
let data: Data = ... // load .mid file as `Data` type
midi.load(data: data)

print(midi.noteTracks.count) // 5
print(midi.noteTracks[0].trackName) // "Bass"
print(midi.noteTracks[1].trackName) // "Piano"
print(midi.noteTracks[2].trackName) // "Hi-hat only"
print(midi.noteTracks[3].trackName) // "Drums"
print(midi.noteTracks[4].trackName) // "Jazz Guitar"

print(midi.tempoTrack.timeSignatures) 
// [MidiParser.MidiTimeSignature(timeStamp: 0.0, numerator: 4, denominator: 2, cc: 24, bb: 8)]
print(midi.tempoTrack.extendedTempos) 
// [MidiParser.MidiExtendedTempo(timeStamp: 0.0, bpm: 120.0)]

print(midi.infoDictionary[.tempo] as! Int) // 120
print(midi.infoDictionary[.timeSignature] as! String) // 4/4
```

### Midi Events
```swift
let track = midi.noteTracks[0]
print(track.count) // number of note events in the track
print(track[0]) // get note event from index with subscript
// MidiNote(timeStamp: 0.0, duration: 0.533333361, note: 45, velocity: 78, channel: 0, releaseVelocity: 64)
```

## Write
```swift
// init empty midi
let midi = MidiData()
// add track
let track1 = midi.addTrack()

// add note events to track1
track1.add(note: MidiNote(timeStamp: 0, duration: 10, note: 50, velocity: 100, channel: 0))
track1.add(notes: [
    MidiNote(timeStamp: 5, duration: 10, note: 40, velocity: 100, channel: 0),
    MidiNote(timeStamp: 10, duration: 10, note: 40, velocity: 100, channel: 0),
    MidiNote(timeStamp: 20, duration: 10, note: 40, velocity: 100, channel: 0)
])

// set meta events
track1.keySignatures = [MidiKeySignature(timeStamp: 0, key: .minor(.A))]
track1.patch = MidiPatch(channel: 0, patch: .cello)
track1.trackName = "track1"

// write data to url
try! midi.writeData(to: tmp)
// generate midi file as Data
let output = midi.createData()
```
open with GarageBand...
<img width="1248" alt="screen shot 2018-07-17 at 10 50 44" src="https://user-images.githubusercontent.com/12775019/42794073-01d61cda-89b8-11e8-85d8-93c8bb43d848.png">

# Installation
## Carthage
To install using Carthage, add the following line to Cartfile:  
`github "matsune/MidiParser"`
