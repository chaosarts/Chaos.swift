//
//  MTLSize+Extensions.swift
//  Pods
//
//  Created by Fu Lam Diep on 17.12.21.
//

import Metal

public extension MTLSize {

    var volume: Int {
        width * height * depth
    }

    init (width: Int) {
        self.init(width: width, height: 1, depth: 1)
    }

    init (height: Int) {
        self.init(width: 1, height: height, depth: 1)
    }

    init (depth: Int) {
        self.init(width: 1, height: 1, depth: depth)
    }

    func with(width: Int) -> MTLSize {
        MTLSize(width: width, height: height, depth: depth)
    }

    func with(height: Int) -> MTLSize {
        MTLSize(width: width, height: height, depth: depth)
    }

    func with(depth: Int) -> MTLSize {
        MTLSize(width: width, height: height, depth: depth)
    }

    func memoryLength<T>(forType type: T.Type) -> Int {
        volume * MemoryLayout<T>.stride
    }
}
