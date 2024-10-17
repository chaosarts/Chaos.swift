//
//  MTLLibrary+Extensions.swift
//  Pods
//
//  Created by Fu Lam Diep on 19.12.21.
//

import Metal

public extension MTLLibrary {

    static func chaosMetalDefault(fromDevice device: MTLDevice? = nil) throws -> MTLLibrary {
        let bundle = Bundle(for: ChaosMetalError.self)
        return try self.default(fromDevice: device, in: bundle)
    }

    static func `default`(fromDevice device: MTLDevice? = nil, in bundle: Bundle = .main) throws -> MTLLibrary {
        do {
            guard let device = device ?? MTLCreateSystemDefaultDevice() else {
                throw ChaosMetalError(code: .noDeviceFound)
            }
            return try device.makeDefaultLibrary(bundle: bundle)
        } catch {
            throw ChaosMetalError(code: .noLibrary)
        }
    }
}
