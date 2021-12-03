//
//  ImageProcessor.swift
//  ChaosMetalExample
//
//  Created by Fu Lam Diep on 03.12.21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI

public enum StateImageViewModel {
    case processing
    case ready(NSImage)
    case error(Error)
    case idle
}
