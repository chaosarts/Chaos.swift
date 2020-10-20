//
//  EnvironmentDataEncoder.swift
//  ChaosKit
//
//  Created by Fu Lam Diep on 19.10.20.
//

import Foundation

public protocol EnvironmentDataEncoder: class {
    var fileExtension: String { get }
    func encode<E: Encodable>(_ encodable: E) throws -> Data
}
