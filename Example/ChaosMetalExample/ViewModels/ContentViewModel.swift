//
//  ContentViewModel.swift
//  ChaosMetalExample
//
//  Created by Fu Lam Diep on 03.12.21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import SwiftUI

public class ContentViewModel: ObservableObject {

    @Published public private(set) var isProcessing: Bool = false

    public var gpuImageProcessor: ImageProcessor = GPUGaussFilterProcessor()

    @Published public var gpuStateImageViewModel: StateImageViewModel

    public var cpuImageProcessor: ImageProcessor = CPUGaussFilterProcessor()

    @Published public var cpuStateImageViewModel: StateImageViewModel

    public init(image: NSImage?) {

        gpuStateImageViewModel = .idle
        cpuStateImageViewModel = .idle

        if let image = image?.copy() as? NSImage {
            gpuStateImageViewModel = .ready(image)
        }

        if let image = image?.copy() as? NSImage {
            cpuStateImageViewModel = .ready(image)
        }
    }

    public func startProcessing() {
        isProcessing = true

        if case .ready(let image) = gpuStateImageViewModel {
            gpuStateImageViewModel = .processing
            DispatchQueue(label: "gpu").async {
                self.gpuImageProcessor.process(image: image, completion: { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let image):
                            self.gpuStateImageViewModel = .ready(image)
                        case .failure(let error):
                            self.gpuStateImageViewModel = .error(error)
                        }

                        if case .processing = self.cpuStateImageViewModel {
                            return
                        }

                        self.isProcessing = true
                    }
                })
            }
        } else {
            gpuStateImageViewModel = .error(NSError(domain: "bla", code: 0, userInfo: nil))
        }

        if case .ready(let image) = cpuStateImageViewModel {
            cpuStateImageViewModel = .processing
            DispatchQueue(label: "cpu").async {
                self.cpuImageProcessor.process(image: image, completion: { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let image):
                            self.cpuStateImageViewModel = .ready(image)
                        case .failure(let error):
                            self.cpuStateImageViewModel = .error(error)
                        }

                        if case .processing = self.gpuStateImageViewModel {
                            return
                        }

                        self.isProcessing = true
                    }
                })
            }
        } else {
            cpuStateImageViewModel = .error(NSError(domain: "bla", code: 0, userInfo: nil))
        }
    }
}
