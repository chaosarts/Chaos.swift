//
//  MTLPrimitiveType.swift
//  ChaosThree
//
//  Created by Fu Lam Diep on 10.09.21.
//

import MetalKit

public extension MTLPrimitiveType {
    var vertexCount: Int {
        switch self {
        case .point, .lineStrip, .triangleStrip:
            return 1
        case .line:
            return 2
        case .triangle:
            return 3
        }
    }
}
