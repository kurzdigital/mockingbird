//
//  Router.swift
//  MockedBackend
//
//  Created by Christian Braun on 29.06.20.
//  Copyright © 2022 KURZDIGITAL Solutions. All rights reserved.
//

import Foundation

public struct Router {
    fileprivate let actionForRoute: [Route: RouteAction]
    let routesAndActions: [RouteAndAction]

    public init(@RouterBuilder _ router: () -> Router) {
        self = router()
    }

    public init(routesAndActions: [RouteAndAction]) {
        self.routesAndActions = routesAndActions.sorted { a, b in
            return a.route.rawValue.split(separator: "/").count < b.route.rawValue.split(separator: "/").count
        }
        var temp = [Route: RouteAction]()
        for route in self.routesAndActions {
            temp[route.route] = route.action
        }

        self.actionForRoute = temp
    }

    public func matchedRoute(_ routeString: String, method: HTTPMethod = .GET) -> Route? {
        return routesAndActions.reversed().first { $0.route.matches(routeString, method: method)}?.route
    }

    public func getContent(for routeString: String, method: HTTPMethod, body: Data?, headers: [String: String]) -> Content? {
        guard let route = matchedRoute(routeString, method: method) else {
            return nil
        }

        let metadata = RequestMetadata(pathParams: route.extractedPathParams(fromUrl: routeString), headers: headers, body: body)
        return actionForRoute[route]?(metadata)
    }
}

@resultBuilder
public struct RouterBuilder {
    public static func buildBlock(_ routesAndActions: RouteAndAction...) -> Router {
        return Router(routesAndActions: routesAndActions)
    }
}
