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
    
    let library = try chaosMetalLibrary(for: commandQueue.device)
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


@inlinable
public func chaosMetalLibrary(for device: MTLDevice) throws -> MTLLibrary {
    do {
        let library = try device.makeDefaultLibrary(bundle: Bundle(for: ChaosMetalError.self))
        return library
    } catch {
        throw ChaosMetalError(code: .noLibrary, previous: error)
    }
}
