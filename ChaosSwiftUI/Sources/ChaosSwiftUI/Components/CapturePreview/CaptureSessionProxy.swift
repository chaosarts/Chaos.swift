//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 23.08.24.
//

import AVFoundation
import Foundation

public protocol CaptureSessionProxy: ObservableObject {
    init()
    func makeSession() -> AVCaptureSession?
}
