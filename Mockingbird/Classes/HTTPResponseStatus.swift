//
//  HTTPResponseStatus.swift
//  Mockingbird
//
//  Created by Christian Braun on 29.09.21.
//  Copyright © 2022 KURZDIGITAL Solutions. All rights reserved.
//

import Foundation

public enum HTTPResponseStatus: Int {
    case ok = 200
    case created
    case accepted
    case nonAuthoritativeInformation
    case noContent
    case resetContent
    case partialContent

    case badRequest = 400
    case unauthorized
    case paymentRequired
    case forbidden
    case notFound
    case methodNotAllowed
    case notAcceptable
    case proxyAuthenticationRequired
    case requestTimeout
    case conflict
    case gone
    case lengthRequired
    case imATeapot = 418

    case internalServerError = 500
    case notImplemented
    case badGateway
    case serviceUnavailable
    case httpVersionNotSupported
}
