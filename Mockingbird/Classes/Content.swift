//
//  Content.swift
//  MockedBackend
//
//  Created by Christian Braun on 29.06.20.
//  Copyright © 2022 KURZDIGITAL Solutions. All rights reserved.
//

import Foundation

public class Content {
    fileprivate(set) var data: Data
    public let statusCode: HTTPResponseStatus
    public var headers = [String: String]()
    public var delay: TimeInterval

    public init(_ string: String, statusCode: HTTPResponseStatus = .ok, delay: TimeInterval = 0) {
        data = string.data(using: .utf8)!
        self.statusCode = statusCode
        self.delay = delay
    }

    public init(_ data: Data, statusCode: HTTPResponseStatus = .ok, delay: TimeInterval = 0) {
        self.data = data
        self.statusCode = statusCode
        self.delay = delay
    }

    public init(filePath: URL, statusCode: HTTPResponseStatus = .ok, delay: TimeInterval = 0) {
        do {
            self.data = try Data(contentsOf: filePath)
            self.statusCode = statusCode
            self.delay = delay
        } catch {
            preconditionFailure("File does not exist: \(filePath) \(error)")
        }
    }

    public init(fileName: String, statusCode: HTTPResponseStatus = .ok, delay: TimeInterval = 0) {
        do {
            self.data = try Data(contentsOf: Bundle.main.url(forResource: fileName, withExtension: "")!)
            self.statusCode = statusCode
            self.delay = delay
        } catch {
            preconditionFailure("File does not exist: \(fileName) \(error)")
        }
    }

    public init<T:Encodable>(encodeable: T, statusCode: HTTPResponseStatus = .ok, encoder: JSONEncoder = JSONEncoder(), delay: TimeInterval = 0) {
        do {
            self.data = try encoder.encode(encodeable)
            self.statusCode = statusCode
            self.delay = delay
        } catch {
            preconditionFailure("Unable to encode object \(error)")
        }
    }

    public func apply(_ replacements: [String: String]) {
        guard let stringData = String(data: data, encoding: .utf8) else {
            print("Can't apply replacements. Data is not utf8 encoded string")
            return
        }

        var resultingString = stringData
        for replacement in replacements {
            resultingString = resultingString.replacingOccurrences(of: replacement.key, with: replacement.value)
        }

        self.data = resultingString.data(using: .utf8)!
    }

    func toHTTPURLResponse(url: URL) -> HTTPURLResponse {
        HTTPURLResponse(url: url, statusCode: statusCode.rawValue, httpVersion: "2.0", headerFields: headers)!
    }
}

#if DEBUG

extension Content {
    static var mocked: Content {
        Content("Mocked")
    }
}

#endif
