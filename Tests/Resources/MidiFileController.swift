//
//  MidiFile.swift
//  MidiParser iOS
//
//  Created by Vladimir Vybornov on 6/20/19.
//  Copyright © 2019 Yuma Matsune. All rights reserved.
//

import Foundation

struct MidiFileController {
    typealias FileName = String
    typealias FileComponents = (name: String, ext: String)
    
    private let bundleSource: AnyClass
    
    init(bundleSource: AnyClass) {
      self.bundleSource = bundleSource
    }
    
    func data(fromFileName fileName: FileName) throws -> Data {
        func getComponent(fromFileName fileName: FileName) throws -> FileComponents {
            let components = fileName.split(separator: ".").compactMap({ String($0) })
            let validComponentsCount = 2
            
            if components.count != validComponentsCount {
                throw MidiFileControllerError.nameInvalid
            }
            
            return FileComponents(name: components[0], ext: components[1])
        }
        
        let fileComponents = try getComponent(fromFileName: fileName)
        
        guard let url = Bundle(for: bundleSource).url(forResource: fileComponents.name, withExtension: fileComponents.ext) else {
            throw MidiFileControllerError.urlInvalid
        }
        
        guard let data = try? Data(contentsOf: url) else {
            throw MidiFileControllerError.midiFormatInvalid
        }

        return data
    }
}

extension MidiFileController {
    
    enum MidiFileControllerError: Error {
        case nameInvalid
        case urlInvalid
        case midiFormatInvalid
    }
}
