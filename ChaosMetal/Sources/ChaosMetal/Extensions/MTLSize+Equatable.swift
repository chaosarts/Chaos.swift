//
//  MTLSize+Equatable.swift
//  Pods
//
//  Created by Fu Lam Diep on 19.12.21.
//

import Metal

extension MTLSize: Equatable {
    public static func == (lhs: MTLSize, rhs: MTLSize) -> Bool {
        lhs.width == rhs.width && lhs.height == lhs.height && rhs.depth == lhs.depth
    }
}
