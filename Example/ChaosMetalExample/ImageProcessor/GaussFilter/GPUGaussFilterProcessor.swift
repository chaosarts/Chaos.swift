//
//  GaussFilter.swift
//  ChaosMetalExample
//
//  Created by Fu Lam Diep on 03.12.21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import AppKit
import ChaosMetal

public class GPUGaussFilterProcessor: ImageProcessor {

    public func process(image: NSImage, completion: @escaping (Result<NSImage, Error>) -> Void) {
        completion(.success(image))
    }

    public func cancel() {
        
    }
}
