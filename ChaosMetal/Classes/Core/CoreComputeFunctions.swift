//
//  Algorithm.swift
//  ChaosMetal
//
//  Created by Fu Lam Diep on 19.11.21.
//

import MetalKit

public func command(forFunction functionName: String, inQueue commandQueue: MTLCommandQueue) throws -> (buffer: MTLCommandBuffer, encoder: MTLComputeCommandEncoder) {
    guard let commandBuffer = commandQueue.makeCommandBuffer() else {
        throw ChaosMetalError(code: .noCommandBuffer)
    }

    guard let commandEncoder = commandBuffer.makeComputeCommandEncoder() else {
        throw ChaosMetalError(code: .noCommandEncoder)
    }
    
    let library = try commandQueue.device.makeChaosMetalDefaultLibrary()
    guard let function = library.makeFunction(name: functionName) else {
        throw ChaosMetalError(code: .functionNotFound)
    }

    do {
        let computePipelineState = try commandQueue.device.makeComputePipelineState(function: function)
        commandEncoder.setComputePipelineState(computePipelineState)
        return (commandBuffer, commandEncoder)
    } catch {
        throw ChaosMetalError(code: .noComputePipelineState, previous: error)
    }
}

public func threadgroupSizeToFit<T>(size: MTLSize, ofType type: T.Type, for device: MTLDevice, reduce: (MTLSize) -> MTLSize) -> MTLSize {

    let elementMemoryLength = MemoryLayout<T>.stride

    let maxThreadsPerThreadgroupByDevice = device.maxThreadsPerThreadgroup

    var threadgroupSize = MTLSize(width: min(size.width, maxThreadsPerThreadgroupByDevice.width),
                                  height: min(size.height, maxThreadsPerThreadgroupByDevice.height),
                                  depth: min(size.depth, maxThreadsPerThreadgroupByDevice.depth))

    let maxThreadgroupMemoryLength = device.maxThreadgroupMemoryLength
    var memoryLength = threadgroupSize.width
        * threadgroupSize.height
        * threadgroupSize.depth
        * elementMemoryLength

    while memoryLength > maxThreadgroupMemoryLength {
        let newThreadgroupSize = reduce(threadgroupSize)
        if newThreadgroupSize.width == threadgroupSize.width,
           newThreadgroupSize.height == threadgroupSize.height,
           newThreadgroupSize.depth == threadgroupSize.depth {
            fatalError("Reduce callback closure does not reduce the size.")
        }

        threadgroupSize = newThreadgroupSize
        memoryLength = threadgroupSize.width
            * threadgroupSize.height
            * threadgroupSize.depth
            * elementMemoryLength
    }

    return threadgroupSize
}
