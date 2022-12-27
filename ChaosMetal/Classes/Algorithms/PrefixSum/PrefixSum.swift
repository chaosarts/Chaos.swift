//
//  PrefixSum.swift
//  Pods
//
//  Created by Fu Lam Diep on 17.12.21.
//

import Metal

public func gpu_prefix_sum(matrix: [Float], width: Int, height: Int, inCommandQueue commandQueue: MTLCommandQueue, completion: ([Float]) -> Void) async throws -> [Float] {
    guard matrix.count == width * height else {
        throw AlgorithmError(code: .matrixSizeMismatch)
    }

    guard let matrixBuffer = commandQueue.device.makeBuffer(length: MemoryLayout<Float>.stride * matrix.count, options: []) else {
        throw ChaosMetalError(code: .noBuffer)
    }

    let output = try await gpu_prefix_sum(matrix: matrixBuffer, width: width, height: height, in: commandQueue)
    return output.contents().load(as: [Float].self)
}

public func gpu_prefix_sum(matrix: MTLBuffer, width: Int, height: Int, in commandQueue: MTLCommandQueue) async throws -> MTLBuffer {
    guard let commandBuffer = commandQueue.makeCommandBuffer() else {
        throw ChaosMetalError(code: .noCommandBuffer)
    }

    guard let commandEncoder = commandBuffer.makeComputeCommandEncoder() else {
        throw ChaosMetalError(code: .noCommandEncoder)
    }

    let library = try commandQueue.device.makeChaosMetalDefaultLibrary()
    guard let function = library.makeFunction(name: "prefix_sum") else {
        throw ChaosMetalError(code: .functionNotFound)
    }
    let elementsPerWarp = 32
    let nextDivisableWidth = max(width - width % elementsPerWarp + elementsPerWarp, elementsPerWarp)
    var threadgroupMatrixSize = sizeToFit(preferredSize: MTLSize(width: nextDivisableWidth, height: height, depth: 1),
                                          type: Float.self,
                                          for: commandQueue.device) { size in
        // First try to reduce size by height, otherwise try to reduce by width. If the sizes doesn't change,
        // `sizeToFit` will raise a fatal error.
        var size = size
        if size.height > 1 {
            size.height = height - 1
        } else if size.width > 1 {
            size.width = max(1, width - elementsPerWarp)
        }
        return size
    }

    let threadgroupMemoryLength = threadgroupMatrixSize.memoryLength(forType: Float.self)
    let N = Int(ceil(log(Float(width)) / log(Float(threadgroupMatrixSize.width))))

    var width = width
    var height = height

    return commandQueue.device.makeBuffer(length: matrix.length)!
}
