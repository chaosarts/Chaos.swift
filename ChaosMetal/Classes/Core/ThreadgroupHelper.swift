//
//  MetalService.swift
//  Pods
//
//  Created by Fu Lam Diep on 19.12.21.
//

import Metal

@objc
public class ThreadgroupHelper: NSObject {

    /// Provides the number in bytes by which a threadgroup buffer size must be devidable.
    public static var threadgroupBaseMemoryLength: Int { 16 }

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

    public static func maxThreadgroupVolumeFittingMemoryLength<T>(_ maxMemoryLength: Int, ofType type: T.Type) -> Int {
        let maxElements = maxMemoryLength / MemoryLayout<T>.stride
        return maxElements - maxElements % threadgroupBaseMemoryLength
    }

    public static func maxThreadgroupVolumeFittingMemoryLength<T>(in device: MTLDevice, ofType type: T.Type) -> Int {
        maxThreadgroupVolumeFittingMemoryLength(device.maxThreadgroupMemoryLength, ofType: type)
    }

    public static func maxThreadgroupVolumeFittingMemoryLength<T>(ofType type: T.Type) throws -> Int {
        guard let device = MTLCreateSystemDefaultDevice() else {
            throw ChaosMetalError(code: .noDeviceFound)
        }
        return maxThreadgroupVolumeFittingMemoryLength(device.maxThreadgroupMemoryLength, ofType: type)
    }

    public static func threadgroupArraySizeFittingMemoryLength<T>(_ maxMemoryLength: Int, ofType type: T.Type, targeting size: MTLSize) {

    }
}
