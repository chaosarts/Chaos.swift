//
//  Algorithm.swift
//  ChaosMetal
//
//  Created by Fu Lam Diep on 19.11.21.
//

import MetalKit

public protocol ParallelComputeAlgorithm {

    func commandQueue (_ environment: Environment) -> MTLCommandQueue?

    func environment (_ environment: Environment, commandBufferFrom commandQueue: MTLCommandQueue) -> MTLCommandBuffer?

    func environment (_ environment: Environment, commandEncoderFrom commandBuffer: MTLCommandBuffer) -> MTLComputeCommandEncoder?

    func function (_ environment: Environment) -> MTLFunction?

    func numberOfBuffers (_ environment: Environment) -> Int

    func environment (_ environment: Environment, bufferAt index: Int) -> MTLBuffer?

    func numberOfThreadGroups (_ environment: Environment) -> MTLSize

    func numberOfThreadsPerGroup (_ environment: Environment) -> MTLSize
}

public extension ParallelComputeAlgorithm {

    func environment (_ environment: Environment, commandBufferFrom commandQueue: MTLCommandQueue) -> MTLCommandBuffer? {
        commandQueue.makeCommandBuffer()
    }

    func environment (_ environment: Environment, commandEncoderFrom commandBuffer: MTLCommandBuffer) -> MTLComputeCommandEncoder? {
        commandBuffer.makeComputeCommandEncoder()
    }
}
