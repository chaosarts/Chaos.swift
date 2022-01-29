//
//  InhibitedDecoder.swift
//  INITCore
//
//  Created by Fu Lam Diep on 15.11.19.
//

import Foundation

/// A decodable class, that defers the autmotated recursive decoding.
///
/// In a decoding process any decodable type will be initialized with the decoder
/// object, where it will extract and cast the the values from corresponding keys.
/// In this class the initialization will not extract any data from the decoder.
/// Hence the decoding process stops at this decoding branch. Instead the decoder
/// is stored in a property.
///
/// When the decoding process is done, a property of this type can be used to
/// manually extract/decode data from this type - either as whole object or at
/// specific keys.
public struct DeferredDecoder: Decodable, Decoder {

    // MARK: - Properties

    /// Provides the decoder holding the data to extract for this branch of
    /// decoding process.
    private var decoder: Decoder


    /// Decodable init method.
    public init(from decoder: Decoder) {
        self.decoder = decoder
        self.codingPath = decoder.codingPath
        self.userInfo = decoder.userInfo
    }


    /// Decodes the whole object as the given type
    /// - Parameter type: The type to which decode this object
    public func decode<T: Decodable>(_ type: T.Type) throws -> T {
        return try T(from: decoder)
    }


    /// Extracts/Decodes the data at given key within this object to the given
    /// type.
    /// - Parameter type: The target type to which to map the data
    /// - Parameter key: The key of the field to fetch the data from
    public func decode<T: Decodable, K: CodingKey> (_ type: T.Type, key: K) throws -> T {
        let container = try decoder.container(keyedBy: K.self)
        return try container.decode(T.self, forKey: key)
    }


    public func decode<T: Decodable, K: CodingKey> (_ type: T.Type, keyPath: [K]) throws -> T {
        guard keyPath.count > 0 else { return try decode(T.self) }

        var container: KeyedDecodingContainer<K> = try decoder.container(keyedBy: K.self)
        for key in keyPath {
            container = try container.nestedContainer(keyedBy: K.self, forKey: key)
        }
        return try T(from: container.superDecoder())
    }


    // MARK: Decoder Implementation

    public var codingPath: [CodingKey]

    public var userInfo: [CodingUserInfoKey : Any]


    public func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        return try decoder.container(keyedBy: type)
    }


    public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        return try decoder.unkeyedContainer()
    }


    public func singleValueContainer() throws -> SingleValueDecodingContainer {
        return try decoder.singleValueContainer()
    }
}
