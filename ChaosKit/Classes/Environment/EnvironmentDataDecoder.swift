//
//  EnvironmentDataDecoder.swift
//  ChaosKit
//
//  Created by Fu Lam Diep on 19.10.20.
//

import Foundation

public protocol EnvironmentDataDecoder: AnyObject {
    var fileExtension: String { get }
    func decode<D: Decodable>(_ type: D.Type, from data: Data) throws -> D
}
