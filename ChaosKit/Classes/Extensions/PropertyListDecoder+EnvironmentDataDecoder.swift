//
//  PropertyListDecoder+EnvironmentDataDecoder.swift
//  ChaosKit
//
//  Created by Fu Lam Diep on 22.10.20.
//

import Foundation


extension PropertyListDecoder: EnvironmentDataDecoder {
    public var fileExtension: String { "plist" } 
}
