//
//  CPUGaussFilterProcessor.swift
//  ChaosMetalExample
//
//  Created by Fu Lam Diep on 03.12.21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import AppKit

public class CPUGaussFilterProcessor: ImageProcessor {

    private struct Process {
        let timer: Timer

        let completion: (Result<NSImage, Error>) -> Void

        var cancelable: Bool { timer.isValid }

        func cancel () {
            guard cancelable else { return }
            timer.invalidate()
            completion(.failure(ImageProcessorError.canceled))
        }
    }

    private var process: Process?

    private var canCancelProcess: Bool {
        process?.cancelable ?? false
    }

    public func process(image: NSImage, completion: @escaping (Result<NSImage, Error>) -> Void) {
        cancel()

        let timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
            completion(.success(image))
            self.cleanup()
        }

        process = Process(timer: timer, completion: completion)
    }

    public func cancel() {
        process?.cancel()
        cleanup()
    }

    private func cleanup () {
        process = nil
    }
}
