//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 19.02.22.
//

import Foundation

public extension KeyedDecodingContainer {

    func decodeSoft<D: Decodable>(_ type: D.Type, forKey key: K) throws -> D? {
        guard contains(key) else { return nil }
        return try decode(type, forKey: key)
    }
}
