//
//  Route.swift
//  MockedBackend
//
//  Created by Christian Braun on 29.06.20.
//  Copyright © 2022 KURZDIGITAL Solutions. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
    case HEAD
}

public struct Route: Equatable, Hashable {
    public let rawValue: String
    public let pathParams: [Int: String]
    public let method: HTTPMethod

    public init(rawValue: String, method: HTTPMethod = .GET) {
        self.rawValue = rawValue
        self.method = method
        pathParams = Self.extractPathParams(rawValue)
    }

    public func matches(_ route: String, method: HTTPMethod = .GET) -> Bool {
        let generatedRegularExpression = generatedRegularExpressionString()
        // The root route always matches but we can not generate a regular expression from it
        let matchesRoute = generatedRegularExpression.isEmpty ?
        true :
        NSRegularExpression(generatedRegularExpression).matches(route)
        return matchesRoute && self.method == method
    }

    public func extractedPathParams(fromUrl url: String) -> [String: String] {
        guard pathParams.isEmpty == false else {
            return [:]
        }
        let urlParts = url.split(separator: "/")
        guard urlParts.count <= rawValue.split(separator: "/").count else {
            preconditionFailure(
                "Can not extract path params when given url does not match expected url pattern. Expected: \(rawValue) given: \(url)")
        }

        var result = [String: String]()
        for pair in pathParams {
            result[pair.value] = String(urlParts[pair.key])
        }

        return result
    }

    public func matches(_ route: Route) -> Bool {
        matches(route.rawValue, method: route.method)
    }

    fileprivate func generatedRegularExpressionString() -> String {
        var result = [String]()
        for (index, part) in rawValue.split(separator: "/").enumerated() {
            if pathParams[index] != nil {
                result.append(".*")
            } else {
                result.append(String(part))
            }
        }
        return result.joined(separator: "/")
    }

    // MARK: - Helpers
    fileprivate static func extractPathParams(_ rawValue: String) -> [Int: String] {
        var tempParams = [Int: String]()
        let parts = rawValue.split(separator: "/")

        for (index, part) in parts.enumerated() where part.contains("{{") && part.contains("}}") {
            let formatedPart = part
                .replacingOccurrences(of: "{{", with: "")
                .replacingOccurrences(of: "}}", with: "")

            tempParams[index] = String(formatedPart)
        }

        return tempParams
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine("\(method)\(rawValue)")
    }
}
