//
//  PrefixSum.swift
//  Pods
//
//  Created by Fu Lam Diep on 17.12.21.
//

import Metal

public func gpu_prefix_sum(matrix: [Float], width: Int, height: Int, inCommandQueue commandQueue: MTLCommandQueue, completion: ([Float]) -> Void) throws {
    guard matrix.count == width * height else {
        throw AlgorithmError(code: .matrixSizeMismatch)
    }

    guard let matrixBuffer = commandQueue.device.makeBuffer(length: MemoryLayout<Float>.stride * matrix.count, options: []) else {
        throw ChaosMetalError(code: .noBuffer)
    }

    try gpu_prefix_sum(matrix: matrixBuffer, width: width, height: height, inCommandQueue: commandQueue, completion: {
        completion($0.contents().load(as: [Float].self))
    })
}

public func gpu_prefix_sum(matrix: MTLBuffer, width: Int, height: Int, inCommandQueue commandQueue: MTLCommandQueue, completion: (MTLBuffer) -> Void) throws {
    let command = try command(forFunction: "prefix_sum", inQueue: commandQueue)

    let next16Bytes = max(width - width % 16, 16)
    var threadgroupSizeByMemory = threadgroupSizeToFit(size: MTLSize(width: next16Bytes, height: next16Bytes, depth: 1),
                                                       ofType: Float.self,
                                                       for: commandQueue.device) { size in
        var size = size
        if size.height > 16 {
            size.height = max(1, height - 16)
        }

        if size.height == 1 {
            size.width = max(1, width - 16)
        }

        return size
    }

    let threadgroupMemoryLength = threadgroupSizeByMemory.memoryLength(forType: Float.self)
    let N = Int(ceil(log(Float(width)) / log(Float(threadgroupSizeByMemory.width))))
    threadgroupSizeByMemory.width /= 2

    var width = width
    var height = height

}
