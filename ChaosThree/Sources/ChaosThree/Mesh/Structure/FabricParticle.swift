//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 19.02.22.
//

import Foundation

public struct FabricParticle {

    private var components: [Int] = Array(repeating: 0, count: 16)

    public var stretching: [Int] {
        Array(components[0..<4])
    }

    public var shearing: [Int] {
        Array(components[4..<8])
    }

    public var bendiing: [Int] {
        Array(components[8..<16])
    }
}
