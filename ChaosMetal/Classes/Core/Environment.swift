//
//  File.swift
//  
//
//  Created by fu.lam.diep on 14.10.22.
//

import Metal

public class Environment {

    public let device: MTLDevice

    public let commandQueue: MTLCommandQueue

    public init?(device: MTLDevice) {
        self.device = device
        guard let commandQueue = device.makeCommandQueue() else {
            return nil
        }
        self.commandQueue = commandQueue
    }

    public convenience init?() {
        guard let device = MTLCreateSystemDefaultDevice() else { return nil }
        self.init(device: device)
    }

    public func library(bundle: Bundle = .main) throws -> MTLLibrary {
        try device.makeDefaultLibrary(bundle: bundle)
    }

    public func chaosMetalLibrary() throws -> MTLLibrary {
        try library(bundle: Bundle(for: Self.self))
    }

    public func run<E: Executable>(executable: E) async throws -> E.Result {
        guard let commandBuffer = commandQueue.makeCommandBuffer() else {
            throw ChaosMetalError(code: .noCommandBuffer)
        }


        // Command Encoder

        guard let commandEncoder = commandBuffer.makeComputeCommandEncoder() else {
            throw ChaosMetalError(code: .noCommandEncoder)
        }

        let library = try executable.library(from: self)
        let function = try await library.makeFunction(name: executable.functionName, constantValues: executable.functionConstants)
        let pipelineState = try await device.makeComputePipelineState(function: function)
        commandEncoder.setComputePipelineState(pipelineState)

        sizeToFit(preferredSize: executable.preferredThreadgroupSize, sizePerElement: 2, for: device) { size in
            size
        }
        executable.encode(in: commandEncoder)
        fatalError()
    }
}

public protocol Executable {

    associatedtype Result

    var functionName: String { get }

    var functionConstants: MTLFunctionConstantValues { get }

    var preferredThreadgroupSize: MTLSize { get }

    func reduceThreadgroupSize(_ input: MTLSize) -> MTLSize

    func library(from environment: Environment) throws -> MTLLibrary
    
    func encode(in encoder: MTLCommandEncoder)
}

public extension Executable {
    func library(from environment: Environment) throws -> MTLLibrary {
        try environment.library()
    }
}
