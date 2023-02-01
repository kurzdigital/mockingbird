//
//  RouteAndAction.swift
//  MockedBackend
//
//  Created by Christian Braun on 29.06.20.
//  Copyright © 2022 KURZDIGITAL Solutions. All rights reserved.
//

import Foundation

public struct RequestMetadata {
    public let pathParams: [String: String]
    public let headers: [String: String]
    public let body: Data?
}

public typealias RouteAction = (RequestMetadata) -> Content

public struct RouteAndAction {
    public let route: Route
    public let action: RouteAction

    public init(_ method: HTTPMethod , url: String, action: @escaping RouteAction) {
        self.route = Route(rawValue: url, method: method)
        self.action = action
    }
}

public func get(_ url: String, action: @escaping RouteAction) -> RouteAndAction {
    RouteAndAction(.GET, url: url, action: action)
}

public func put(_ url: String, action:  @escaping RouteAction) -> RouteAndAction {
    RouteAndAction(.PUT, url: url, action: action)
}

public func post(_ url: String, action:  @escaping RouteAction) -> RouteAndAction {
    RouteAndAction(.POST, url: url, action: action)
}

public func delete(_ url: String, action:  @escaping RouteAction) -> RouteAndAction {
    RouteAndAction(.DELETE, url: url, action: action)
}
