//
//  ImageProcessor.swift
//  ChaosMetalExample
//
//  Created by Fu Lam Diep on 03.12.21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import AppKit

public protocol ImageProcessor {

    func process(image: NSImage, completion: @escaping (Result<NSImage, Error>) -> Void)
    func cancel()
}


public enum ImageProcessorError: Error {
    case canceled
}
