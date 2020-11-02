//
//  HttpStatus.swift
//  ChaosNet
//
//  Created by Fu Lam Diep on 29.10.20.
//

import Foundation


public struct HttpStatus {

    // MARK: Properties

    /// Provides the code of the http status
    public let code: Int

    /// Provides a textual description of the status
    public let text: String?

    /// Provides the category of the http status
    public var category: Category {
        return .from(code: code)
    }


    // MARK: Initialization

    /// Initializes the http status with its code and a optional textual description
    public init(_ code: Int, text: String? = nil) {
        self.code = code
        self.text = text
    }
}


// MARK: - HTTP Status Instances

extension HttpStatus {

    // - MARK: 1xx-status
    public static let `continue`: HttpStatus = .init(100, text: "Continue")
    public static let switchingProtocols: HttpStatus = .init(101, text: "Switching Protocols")

    // - MARK: 2xx-status
    public static let ok: HttpStatus = .init(200, text: "OK")
    public static let created: HttpStatus = .init(201, text: "Created")
    public static let accepted: HttpStatus = .init(202, text: "Accepted")
    public static let nonAuthoritativeInformation: HttpStatus = .init(203, text: "Non-Authoritative Information")
    public static let noContent: HttpStatus = .init(204, text: "No Content")
    public static let resetContent: HttpStatus = .init(205, text: "Reset Content")
    public static let partialContent: HttpStatus = .init(206, text: "Partial Content")
    public static let multiStatus: HttpStatus = .init(207, text: "Multi-Status")
    public static let alreadyReported: HttpStatus = .init(208, text: "Already Reported")
    public static let imUsed: HttpStatus = .init(226, text: "IM Used")

    // - MARK: 3xx-status
    public static let multipleChoices: HttpStatus = .init(300, text: "Multiple Choices")
    public static let movedPermanently: HttpStatus = .init(301, text: "Moved Permanently")
    public static let found: HttpStatus = .init(302, text: "Found (Moved Temporarily)")
    public static let seeOther: HttpStatus = .init(303, text: "See Other")
    public static let notModified: HttpStatus = .init(304, text: "Not Modified")
    public static let useProxy: HttpStatus = .init(305, text: "Use Proxy")
    public static let temporaryRedirect: HttpStatus = .init(307, text: "Temporary Redirect")
    public static let permanentRedirect: HttpStatus = .init(308, text: "Permanent Redirect")

    // - MARK: 4xx-status
    public static let badRequest: HttpStatus = .init(400, text: "Bad Request")
    public static let unauthorized: HttpStatus = .init(401, text: "Unauthorized")
    public static let paymentRequired: HttpStatus = .init(402, text: "Payment Required")
    public static let forbidden: HttpStatus = .init(403, text: "Forbidden")
    public static let notFound: HttpStatus = .init(404, text: "Not Found")
    public static let methodNotAllowed: HttpStatus = .init(405, text: "Method Not Allowed")
    public static let notAcceptable: HttpStatus = .init(406, text: "Not Acceptable")
    public static let proxyAuthenticationRequired: HttpStatus = .init(407, text: "Proxy Authentication Required")
    public static let requestTimeout: HttpStatus = .init(408, text: "Request Timeout")
    public static let conflict: HttpStatus = .init(409, text: "Conflict")
    public static let gone: HttpStatus = .init(410, text: "Gone")
    public static let lengthRequired: HttpStatus = .init(411, text: "Length Required")
    public static let preconditionFailed: HttpStatus = .init(412, text: "Precondition Failed")
    public static let requestEntityTooLarge: HttpStatus = .init(413, text: "Request Entity Too Large")
    public static let uRITooLong: HttpStatus = .init(414, text: "URI Too Long")
    public static let unsupportedMediaType: HttpStatus = .init(415, text: "Unsupported Media Type")
    public static let requestedRangeNotSatisfiable: HttpStatus = .init(416, text: "Requested range not satisfiable")
    public static let expectationFailed: HttpStatus = .init(417, text: "Expectation Failed")
    public static let policyNotFulfilled: HttpStatus = .init(420, text: "Policy Not Fulfilled")
    public static let misdirectedRequest: HttpStatus = .init(421, text: "Misdirected Request")
    public static let unprocessableEntity: HttpStatus = .init(422, text: "Unprocessable Entity")
    public static let locked: HttpStatus = .init(423, text: "Locked")
    public static let failedDependency: HttpStatus = .init(424, text: "Failed Dependency")
    public static let upgradeRequired: HttpStatus = .init(426, text: "Upgrade Required")
    public static let preconditionRequired: HttpStatus = .init(428, text: "Precondition Required")
    public static let tooManyRequests: HttpStatus = .init(429, text: "Too Many Requests")
    public static let requestHeaderFieldsTooLarge: HttpStatus = .init(431, text: "Request Header Fields Too Large")
    public static let unavailableForLegalReasons: HttpStatus = .init(451, text: "Unavailable For Legal Reasons")

    // - MARK: 5xx-status
    public static let internalServerError: HttpStatus = .init(500, text: "Internal Server Error")
    public static let notImplemented: HttpStatus = .init(501, text: "Not Implemented")
    public static let badGateway: HttpStatus = .init(502, text: "Bad Gateway")
    public static let serviceUnavailable: HttpStatus = .init(503, text: "Service Unavailable")
    public static let gatewayTimeout: HttpStatus = .init(504, text: "Gateway Timeout")
    public static let hTTPVersionNotSupported: HttpStatus = .init(505, text: "HTTP Version not supported")
    public static let variantAlsoNegotiates: HttpStatus = .init(506, text: "Variant Also Negotiates")
    public static let insufficientStorage: HttpStatus = .init(507, text: "Insufficient Storage")
    public static let loopDetected: HttpStatus = .init(508, text: "Loop Detected")
    public static let bandwidthLimitExceeded: HttpStatus = .init(509, text: "Bandwidth Limit Exceeded")
    public static let notExtended: HttpStatus = .init(510, text: "Not Extended")
    public static let networkAuthenticationRequired: HttpStatus = .init(511, text: "Network Authentication Required")
}


// MARK: - Equatable Implementation

extension HttpStatus {
    public static func ==(lhs: HttpStatus, rhs: HttpStatus) -> Bool {
        return lhs.code == rhs.code
    }
}


// MARK: - CustomStringConvertible Implementation

extension HttpStatus {
    public var description: String {
        guard let text = text else { return "\(code)" }
        return "\(code) \(text)"
    }
}


// MARK: - HttpStatusCategory


public extension HttpStatus {

    enum Category: Int {
        case information = 1
        case success = 2
        case redirection = 3
        case clientError = 4
        case serverError = 5
        case proprietaryError = 9
        case unknown

        public static func from(code: Int) -> Category {
            return Category(rawValue: code / 100) ?? .unknown
        }

        public var isError: Bool {
            [.clientError, .serverError, .proprietaryError].contains(self)
        }
    }
}

