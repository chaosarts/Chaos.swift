//
//  Environment.swift
//  ChaosMetal
//
//  Created by Fu Lam Diep on 12.09.21.
//

import MetalKit
import ChaosCore

@objc public class Environment: NSObject {

    public let device: MTLDevice

    private let logger: Log

    public init (device: MTLDevice) {
        self.device = device
        self.logger = Log(Environment.self)
    }

    public func execute(algorithm: ParallelComputeAlgorithm, completion: (Error?) -> Void) throws {
        guard let commandQueue = algorithm.commandQueue(self) else {
            throw EnvironmentError(code: .noCommandQueue)
        }
        
        guard let commandBuffer = algorithm.environment(self, commandBufferFrom: commandQueue) else {
            throw EnvironmentError(code: .noCommandBuffer, message: "Could not create command buffer")
        }

        guard let commandEncoder = algorithm.environment(self, commandEncoderFrom: commandBuffer) else {
            throw EnvironmentError(code: .noCommandEncoder, message: "Unable to create command encoder")
        }

        guard let function = algorithm.function(self) else {
            throw EnvironmentError(code: .functionNotFound, message: "Unable to find function")
        }

        do {
            let pipeline = try device.makeComputePipelineState(function: function)
            commandEncoder.setComputePipelineState(pipeline)
        } catch {
            throw EnvironmentError(code: .functionNotFound, message: "", previous: error)
        }

        let numberOfBuffers = algorithm.numberOfBuffers(self)
        guard numberOfBuffers > 0 else {
            throw EnvironmentError(code: .invalidNumberOfBuffers, message: "Algorithm must have at least one buffer for input or output.")
        }

        for index in 0..<numberOfBuffers {
            guard let buffer = algorithm.environment(self, bufferAt: index) else {
                throw EnvironmentError(code: .noBuffer)
            }
            commandEncoder.setBuffer(buffer, offset: 0, index: index)
        }

        let numberOfThreadGroups = algorithm.numberOfThreadGroups(self)
        let numberOfThreadsPerGroup = algorithm.numberOfThreadsPerGroup(self)

        commandEncoder.dispatchThreadgroups(numberOfThreadGroups, threadsPerThreadgroup: numberOfThreadsPerGroup)
        commandEncoder.endEncoding()
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
    }
}
