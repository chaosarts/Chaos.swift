//
//  Environment.swift
//  ChaosMetal
//
//  Created by Fu Lam Diep on 12.09.21.
//

import MetalKit

public class Environment {

    public let device: MTLDevice

    public init (device: MTLDevice) {
        self.device = device
    }

    public convenience init? () {
        guard let device = MTLCreateSystemDefaultDevice() else {
            return nil
        }
        self.init(device: device)
    }
}
