//
//  JSONDecoder+EnvironmentDataDecoder.swift
//  ChaosKit
//
//  Created by Fu Lam Diep on 19.10.20.
//

import Foundation

extension JSONDecoder: EnvironmentDataDecoder {
    public var fileExtension: String { "json" }
}
