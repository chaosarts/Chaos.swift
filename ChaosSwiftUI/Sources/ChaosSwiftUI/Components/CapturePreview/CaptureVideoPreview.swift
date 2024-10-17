//
//  CaptureVideoPreview.swift
//
//  Created by Fu Lam Diep on 23.08.24.
//

#if canImport(UIKit)
import AVFoundation
import SwiftUI

public struct CaptureVideoPreview<Proxy>: UIViewControllerRepresentable where Proxy: CaptureSessionProxy {

    private let isRunning: Bool

    private let sessionProxy: Proxy

    public init(_ isRunning: Bool, sessionProxy: Proxy) {
        self.isRunning = isRunning
        self.sessionProxy = sessionProxy
    }

    public func makeUIViewController(context: Context) -> some UIViewController {
        let controller = UICaptureVideoCapturePreviewController()
        controller.session = sessionProxy.makeSession()
        return controller
    }

    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        let controller = (uiViewController as? UICaptureVideoCapturePreviewController)
        controller?.setSessionRunning(isRunning)
    }
}
#endif
