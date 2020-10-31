//
//  HttpHeader.swift
//  ChaosNet
//
//  Created by Fu Lam Diep on 29.10.20.
//

import Foundation

/// Struct to represent an http header, containing a name and an optional value. Http headers
/// are build as *name*: *value*.
public struct HttpHeader {

    // MARK: Properties

    /// Provides the name of the http header.
    public let name: String

    /// Provides an optional value of the http header.
    public var value: String


    // MARK: Initialization

    public init (name: String, value: String) {
        self.name = name
        self.value = value
    }
}


// MARK: - CustomStringConvertible

extension HttpHeader {
    public var description: String { "\(name): \(value)" }
}


// MARK: -

extension HttpHeader {

    public static func contentType(value: String) -> HttpHeader {
        return HttpHeader(name: "Content-Type", value: value.description)
    }

    public static func contentType(value: MimeType) -> HttpHeader {
        return contentType(value: value.description)
    }

    public static func contentLength(bytes: Int) -> HttpHeader {
        return HttpHeader(name: "Content-Length", value: "\(bytes)")
    }
}
