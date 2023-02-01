//
//  MockingbirdURLProtocol.swift
//  Mockingbird
//
//  Created by Christian Braun on 28.09.21.
//  Copyright © 2022 KURZDIGITAL Solutions. All rights reserved.
//

import Foundation
enum MockingbirdURLProtocolError: Error {
    case urlIsNil
    case unsupportedHttpMethod
}

public class MockingbirdURLProtocol: URLProtocol {
    public static var router = Router(routesAndActions: [])

    public override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    public override func startLoading() {
        if Self.router.routesAndActions.isEmpty {
            debugPrint("Looks like the router does not contain any routes to mock.")
        }
        guard let url = request.url else {
            client?.urlProtocol(self, didFailWithError: MockingbirdURLProtocolError.urlIsNil)
            return
        }
        guard let method = HTTPMethod(rawValue: request.httpMethod ?? "") else {
            client?.urlProtocol(self, didFailWithError: MockingbirdURLProtocolError.unsupportedHttpMethod)
            return
        }
        debugPrint("About to mock response for: \(url.absoluteString) – \(method.rawValue)")
        let body: Data?
        if let inputStream = request.httpBodyStream {
            body = Data(reading: inputStream)
        } else {
            body = request.httpBody
        }
        guard let content = Self.router.getContent(for: url.path, method: method, body: body, headers: request.allHTTPHeaderFields ?? [:]) else {
            let notFoundResponse = HTTPURLResponse(
                url: url,
                statusCode: HTTPResponseStatus.notFound.rawValue,
                httpVersion: "2.0",
                headerFields: nil)!
            debugPrint("No content found for \(url.absoluteString): Returning 404")
            client?.urlProtocol(self, didReceive: notFoundResponse, cacheStoragePolicy: .notAllowed)
            client?.urlProtocolDidFinishLoading(self)
            return
        }

        let response = content.toHTTPURLResponse(url: url)
        let callBlock = { [weak self] in
            guard let self = self else {
                return
            }
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            self.client?.urlProtocol(self, didLoad: content.data)
            self.client?.urlProtocolDidFinishLoading(self)
        }
        if content.delay == 0 {
            callBlock()
        } else {
            DispatchQueue.global().asyncAfter(deadline: .now() + content.delay, execute: callBlock)
        }
    }

    public override func stopLoading() {
    }

    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
}
