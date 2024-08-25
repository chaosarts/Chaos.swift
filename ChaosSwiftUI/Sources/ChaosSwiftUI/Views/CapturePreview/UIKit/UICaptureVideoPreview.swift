//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 23.08.24.
//

import AVFoundation
import UIKit

class UICaptureVideoPreview: UIView {
    override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }
    var videoPreviewLayer: AVCaptureVideoPreviewLayer! { layer as? AVCaptureVideoPreviewLayer }
}
