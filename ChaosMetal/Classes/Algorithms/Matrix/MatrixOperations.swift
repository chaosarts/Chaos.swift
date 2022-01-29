//
//  Scan.swift
//  ChaosMetal
//
//  Created by Fu Lam Diep on 19.11.21.
//

import MetalKit


public func gpu_transpose (matrix: [Float],
                           width: UInt,
                           height: UInt? = nil,
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
                                  width: UInt,
                                  height: UInt,
                                  tileSize: UInt = 128,
                                  inCommandQueue commandQueue: MTLCommandQueue,
                                  completion: @escaping (MTLBuffer) -> Void) {

    guard var output = commandQueue.device.makeBuffer(length: matrix.length, options: []) else {
        fatalError("Unable to create output buffer")
    }

    do {
        let command = try command(forFunction: "matrix_transpose", inQueue: commandQueue)

        // Prepare Arguments

        var tileSize = tileSize
        var matrixSize = SIMD2<UInt>(width, height)

        command.encoder.setBuffer(matrix, offset: 0, index: 0)
        command.encoder.setBytes(&matrixSize, length: MemoryLayout<SIMD2<UInt>>.stride, index: 1)
        command.encoder.setBytes(&tileSize, length: MemoryLayout<SIMD2<UInt>>.stride, index: 2)
        command.encoder.setBuffer(output, offset: 0, index: 3)
        command.encoder.setThreadgroupMemoryLength(MemoryLayout<Float>.stride * Int(tileSize) * Int(tileSize), index: 0)


        // Specify Threadgroups

        let threadgroupsPerGrid = MTLSize(width: Int(floor(Float(width) / Float(tileSize))),
                                          height: Int(floor(Float(height) / Float(tileSize))),
                                          depth: 1)
        let threadsPerThreadgroup = MTLSize(width: Int(tileSize),
                                            height: 1,
                                            depth: 1)

        command.encoder.dispatchThreadgroups(threadgroupsPerGrid, threadsPerThreadgroup: threadsPerThreadgroup)


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
        let err = error
        fatalError(error.localizedDescription)
    }
}
