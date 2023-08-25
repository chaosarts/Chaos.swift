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

public func sizeToFit<T>(preferredSize size: MTLSize, type: T.Type, for device: MTLDevice, reduce: (MTLSize) -> MTLSize) -> MTLSize {
    var threadgroupSize = MTLSize(width: min(size.width, device.maxThreadsPerThreadgroup.width),
                                  height: min(size.height, device.maxThreadsPerThreadgroup.height),
                                  depth: min(size.depth, device.maxThreadsPerThreadgroup.depth))

    while threadgroupSize.memoryLength(forType: T.self) > device.maxThreadgroupMemoryLength {
        let newThreadgroupSize = reduce(threadgroupSize)
        if newThreadgroupSize == threadgroupSize {
            fatalError("Reduce callback closure does not reduce the size.")
        }

        threadgroupSize = newThreadgroupSize
    }

    return threadgroupSize
}

public func sizeToFit(preferredSize size: MTLSize, sizePerElement: Int, for device: MTLDevice, reduce: (MTLSize) -> MTLSize) -> MTLSize {
    var threadgroupSize = MTLSize(width: min(size.width, device.maxThreadsPerThreadgroup.width),
                                  height: min(size.height, device.maxThreadsPerThreadgroup.height),
                                  depth: min(size.depth, device.maxThreadsPerThreadgroup.depth))
    
    while threadgroupSize.volume * sizePerElement > device.maxThreadgroupMemoryLength {
        let newThreadgroupSize = reduce(threadgroupSize)
        if newThreadgroupSize == threadgroupSize {
            fatalError("Reduce callback closure does not reduce the size.")
        }

        threadgroupSize = newThreadgroupSize
    }

    return threadgroupSize
}
