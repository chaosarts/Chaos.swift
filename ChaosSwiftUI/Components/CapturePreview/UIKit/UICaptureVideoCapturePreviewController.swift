//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 23.08.24.
//

#if canImport(UIKit)
import AVFoundation
import UIKit

class UICaptureVideoCapturePreviewController: UIViewController {

    var captureView: UICaptureVideoPreview! {
        view as? UICaptureVideoPreview
    }

    var session: AVCaptureSession? {
        get { captureView.videoPreviewLayer.session }
        set { captureView.videoPreviewLayer.session = newValue }
    }

    var videoGarvity: AVLayerVideoGravity = .resizeAspectFill

    var queue: DispatchQueue = .global()

    override func loadView() {
        view = UICaptureVideoPreview()
    }

    func setSessionRunning(_ running: Bool) {
        if running {
            queue.async { [weak self] in
                self?.session?.startRunning()
            }
        } else {
            session?.stopRunning()
        }
    }

    deinit {
        session?.stopRunning()
    }
}
#endif
