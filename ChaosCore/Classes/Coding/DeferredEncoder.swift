//
//  InhibitedEncoder.swift
//  INITCore
//
//  Created by Fu Lam Diep on 02.01.20.
//

import Foundation

@available(*, renamed: "DeferredEncoder")
public typealias EncoderProxy = DeferredEncoder

/// A class to defer the encoding process of objects.
///
/// Instead of defining a new class to encode to a certain format (e.g. json)
public struct DeferredEncoder: Encodable {

    private let callback: (Encoder) throws -> Void

    public init (callback: @escaping (Encoder) throws -> Void) {
        self.callback = callback
    }

    public func encode(to encoder: Encoder) throws {
        try callback(encoder)
    }
}
