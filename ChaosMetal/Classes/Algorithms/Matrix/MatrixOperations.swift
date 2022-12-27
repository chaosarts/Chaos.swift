//
//  Scan.swift
//  ChaosMetal
//
//  Created by Fu Lam Diep on 19.11.21.
//

import MetalKit

public func gpu_transpose (matrix: [Float], width: Int, height: Int? = nil, inCommandQueue commandQueue: MTLCommandQueue) async throws -> [Float] {
    let height = height ?? width
    guard width * height == matrix.count else {
        throw AlgorithmError(code: .matrixSizeMismatch)
    }

    let matrixLenght = MemoryLayout<Float>.stride * matrix.count
    var inputMatrix = matrix

    guard let input = commandQueue.device.makeBuffer(bytes: &inputMatrix, length: matrixLenght, options: []) else {
        throw ChaosMetalError(code: .noBuffer)
    }

    let buffer = try await gpu_matrix_transpose(matrix: input, width: width, height: height, in: commandQueue)
    var output = [Float]()

    let contents = buffer.contents()
    let length = MemoryLayout<Float>.stride
    for offset in 0..<matrix.count {
        output.append(contents.load(fromByteOffset: length * offset, as: Float.self))
    }
    return output
}

public func gpu_matrix_transpose (matrix: MTLBuffer, width: Int, height: Int, in commandQueue: MTLCommandQueue) async throws -> MTLBuffer {

    guard let output = commandQueue.device.makeBuffer(length: matrix.length, options: []) else {
        throw ChaosMetalError(code: .noBuffer)
    }

    let command = try command(forFunction: "matrix_transpose", inQueue: commandQueue)

    // Prepare Arguments


    var threadgroupArrayVolume = commandQueue.device.maxThreadgroupMemoryLength / MemoryLayout<Float>.stride
    threadgroupArrayVolume = threadgroupArrayVolume - threadgroupArrayVolume % 4

    let threadgroupArraySize = MTLSize(width: commandQueue.device.maxThreadsPerThreadgroup.width -
                                       commandQueue.device.maxThreadsPerThreadgroup.width % 4)

    var width = width
    var height = height
    command.encoder.setBuffer(matrix, offset: 0, index: 0)
    command.encoder.setBytes(&width, length: MemoryLayout<Int>.stride, index: 1)
    command.encoder.setBytes(&height, length: MemoryLayout<Int>.stride, index: 2)
    command.encoder.setBuffer(output, offset: 0, index: 3)
    command.encoder.setThreadgroupMemoryLength(threadgroupArraySize.memoryLength(forType: Float.self),
                                               index: 0)


    // Specify Threadgroups

    let gridHeight: Int = Int(ceil(Float(height) / Float(threadgroupArraySize.width)))
    let gridSize = MTLSize(width: width, height: gridHeight, depth: 1)
    command.encoder.dispatchThreadgroups(gridSize, threadsPerThreadgroup: threadgroupArraySize.with(height: 1))


    // Finalize
    return await withCheckedContinuation { continuation in
        command.buffer.addCompletedHandler { buffer in
            buffer.logs.forEach({ functionLog in
                print(functionLog)
            })
            continuation.resume(with: .success(output))
        }

        command.encoder.endEncoding()
        command.buffer.commit()
    }
}
