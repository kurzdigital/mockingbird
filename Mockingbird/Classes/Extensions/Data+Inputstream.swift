//
//  Data+Inputstream.swift
//  Mockingbird
//
//  Created by Christian Braun on 30.09.21.
//  Copyright © 2022 KURZDIGITAL Solutions. All rights reserved.
//

import Foundation

extension Data {
    /**
     Consumes the specified input stream, creating a new Data object
     with its content.
     - Parameter reading: The input stream to read data from.
     - Note: Closes the specified stream.
     */
    init(reading input: InputStream) {
        self.init()
        input.open()

        let bufferSize = 1024
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        while input.hasBytesAvailable {
            let read = input.read(buffer, maxLength: bufferSize)
            self.append(buffer, count: read)
        }
        buffer.deallocate()

        input.close()
    }

    /**
        Consumes the specified input stream for up to `byteCount` bytes,
        creating a new Data object with its content.
        - Parameter reading: The input stream to read data from.
        - Parameter byteCount: The maximum number of bytes to read from `reading`.
        - Note: Does _not_ close the specified stream.
    */
    init(reading input: InputStream, for byteCount: Int) {
        self.init()
        input.open()

        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: byteCount)
        let read = input.read(buffer, maxLength: byteCount)
        self.append(buffer, count: read)
        buffer.deallocate()
    }
}
