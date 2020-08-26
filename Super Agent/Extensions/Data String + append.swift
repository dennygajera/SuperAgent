//
//  Data String + append.swift
//  ADBlock X
//
//  Created by Alexey Voronov on 18/06/2019.
//  Copyright © 2019 Anton Antonov. All rights reserved.
//

import Foundation

extension String {
    func appendLineToURL(fileURL: URL) throws {
        try ("\n" + self).appendToURL(fileURL: fileURL)
    }
    
    func appendToURL(fileURL: URL) throws {
        let data = self.data(using: String.Encoding.utf8)!
        try data.append(fileURL: fileURL)
    }
}

extension Data {
    func append(fileURL: URL) throws {
        if let fileHandle = FileHandle(forWritingAtPath: fileURL.path) {
            defer {
                fileHandle.closeFile()
            }
            fileHandle.seekToEndOfFile()
            fileHandle.write(self)
        }
        else {
            try write(to: fileURL, options: .atomic)
        }
    }
}
