//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 15.02.22.
//

import Foundation
import Metal

public class MetalRenderer: Renderer {

    private var commandQueue: MTLCommandQueue

    public var device: MTLDevice { commandQueue.device }

    private var renderPassDescriptor: MTLRenderPassDescriptor = MTLRenderPassDescriptor()

    public init?(device: MTLDevice? = nil) {
        guard let device = device ?? MTLCreateSystemDefaultDevice(),
        let commandQueue = device.makeCommandQueue() else {
            return nil
        }
        self.commandQueue = commandQueue
    }
}
