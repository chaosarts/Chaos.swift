//
//  Scan.swift
//  ChaosMetal
//
//  Created by Fu Lam Diep on 19.11.21.
//

import MetalKit


public func gpu_transpose (matrix: [Float],
                           width: Int,
                           height: Int? = nil,
                           inCommandQueue commandQueue: MTLCommandQueue,
                           completion: @escaping ([Float]) -> Void) {
    let height = height ?? width
    guard width * height == matrix.count else {
        fatalError("Specified width and height does not match the size of the given matrix.")
    }

    let length = MemoryLayout<Float>.stride * matrix.count
    var inputMatrix = matrix

    guard let input = commandQueue.device.makeBuffer(bytes: &inputMatrix, length: length, options: []) else {
        fatalError("Unable to create input buffer for matrix.")
    }

    gpu_matrix_transpose(matrix: input,
                         width: width,
                         height: height,
                         inCommandQueue: commandQueue) { buffer in
        var output = [Float]()

        let contents = buffer.contents()
        let length = MemoryLayout<Float>.stride
        for offset in 0..<matrix.count {
            output.append(contents.load(fromByteOffset: length * offset, as: Float.self))
        }
        completion(output)
    }
}

public func gpu_matrix_transpose (matrix: MTLBuffer,
                                  width: Int,
                                  height: Int,
                                  inCommandQueue commandQueue: MTLCommandQueue,
                                  completion: @escaping (MTLBuffer) -> Void) {

    guard let output = commandQueue.device.makeBuffer(length: matrix.length, options: []) else {
        fatalError("Unable to create output buffer")
    }

    do {
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


        // Handle Completion

        command.buffer.addCompletedHandler { buffer in
            buffer.logs.forEach({ functionLog in
                print(functionLog)
            })
            completion(output)
        }


        // Finalize

        command.encoder.endEncoding()
        command.buffer.commit()
    } catch {
        fatalError(error.localizedDescription)
    }
}
