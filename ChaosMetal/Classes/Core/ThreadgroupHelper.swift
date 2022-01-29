//
//  MetalService.swift
//  Pods
//
//  Created by Fu Lam Diep on 19.12.21.
//

import Metal
import ChaosMath

@objc
public class ThreadgroupHelper: NSObject {

    /// Provides the number in bytes by which a threadgroup buffer size must be devidable.
    public static var baseMemoryLength: Int { 16 }

    public static func maxThreadgroupArraySize<T> (ofType type: T.Type,
                                                   fitting size: MTLSize,
                                                   in device: MTLDevice,
                                                   constraintTo maxMemoryLength: Int? = nil,
                                                   reduce: (MTLSize, Int) -> MTLSize) throws -> MTLSize {
        let maxMemoryLength = min(maxMemoryLength ?? device.maxThreadgroupMemoryLength,
                                  device.maxThreadgroupMemoryLength)

        var size = MTLSize(width: min(device.maxThreadsPerThreadgroup.width, size.width),
                           height: min(device.maxThreadsPerThreadgroup.height, size.height),
                           depth: min(device.maxThreadsPerThreadgroup.depth, size.depth))
        
        var memoryLength = size.memoryLength(forType: type)
        while memoryLength >= maxMemoryLength {
            let newSize = reduce(size, memoryLength)
            if newSize.volume >= size.volume || newSize.volume == 0 {
                throw AlgorithmError(code: .invalidReduceCallback)
            }
            size = newSize
            memoryLength = size.memoryLength(forType: type)
        }

        return size
    }

    /// Determines the number of elements fitting into the specified memory.
    ///
    /// - Parameter maxMemoryLength: The memory length constraint
    /// - Parameter divisor: Specifies the minimum memory length, in which an element fits and is divisble by `baseMemoryLength`
    /// - Returns: The number elements fitting the given `maxMemoryLength`, that is divisble by stride
    private static func maxElementCountFittingMemoryLength(_ maxMemoryLength: Int, divisibleBy stride: Int) -> Int {
        let maxElements = maxMemoryLength / stride
        return maxElements - maxElements % stride
    }

    public static func maxElementCountFittingMemoryLength<T>(_ maxMemoryLength: Int, ofType type: T.Type) -> Int {
        let typeMemoryLength = MemoryLayout<T>.stride
        let divisor = typeMemoryLength > baseMemoryLength ? lcm(typeMemoryLength, baseMemoryLength) : baseMemoryLength
        return maxElementCountFittingMemoryLength(maxMemoryLength, divisibleBy : divisor)
    }

    public static func maxElementCountFittingMemoryLength<T>(in device: MTLDevice, ofType type: T.Type) -> Int {
        maxElementCountFittingMemoryLength(device.maxThreadgroupMemoryLength, ofType: type)
    }

    public static func maxElementCountFittingMemoryLength<T>(ofType type: T.Type) throws -> Int {
        guard let device = MTLCreateSystemDefaultDevice() else {
            throw ChaosMetalError(code: .noDeviceFound)
        }
        return maxElementCountFittingMemoryLength(device.maxThreadgroupMemoryLength, ofType: type)
    }
}
