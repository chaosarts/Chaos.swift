//
//  Scan.swift
//  ChaosMetal
//
//  Created by Fu Lam Diep on 19.11.21.
//

import MetalKit

@objc public class Scan: NSObject, ParallelComputeAlgorithm {

    public private(set) var values: [Float] = []

    private var commandQueue: MTLCommandQueue?

    private var library: MTLLibrary?

    private var function: MTLFunction?

    public func commandQueue (_ environment: Environment) -> MTLCommandQueue? {
        guard let commandQueue = commandQueue else {
            commandQueue = environment.device.makeCommandQueue()
            return commandQueue
        }
        return commandQueue
    }


    private func library(_ environment: Environment) -> MTLLibrary? {
        guard let library = library else {
            library = environment.device.makeDefaultLibrary()
            return library
        }
        return library
    }

    public func function(_ environment: Environment) -> MTLFunction? {
        guard let function = function else {
            function = library(environment)?.makeFunction(name: "scan1d")
            return function
        }
        return function
    }

    public func numberOfBuffers(_ environment: Environment) -> Int {
        2
    }

    public func environment(_ environment: Environment, bufferAt index: Int) -> MTLBuffer? {
        switch index {
        case 0:
            return environment.device.makeBuffer(bytes: &values, length: MemoryLayout<Float>.size * values.count, options: [])
        case 1:
            return environment.device.makeBuffer(length: MemoryLayout<Float>.size * values.count, options: [])
        default:
            return nil
        }
    }

    public func numberOfThreadGroups(_ environment: Environment) -> MTLSize {
        MTLSize(width: 0, height: 0, depth: 0)
    }

    public func numberOfThreadsPerGroup(_ environment: Environment) -> MTLSize {
        MTLSize(width: 0, height: 0, depth: 0)
    }

}
