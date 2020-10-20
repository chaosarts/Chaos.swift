//
//  JSONEncoder+EnvironmentDataEncoder.swift
//  ChaosKit
//
//  Created by Fu Lam Diep on 19.10.20.
//

import Foundation

extension JSONEncoder: EnvironmentDataEncoder {
    public var fileExtension: String { "json" }
}
