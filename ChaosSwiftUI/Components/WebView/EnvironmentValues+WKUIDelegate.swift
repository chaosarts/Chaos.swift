//
//  Copyright © 2024 Fu Lam Diep <fulam.diep@gmail.com>
//

import SwiftUI
import WebKit

extension EnvironmentValues {
    @Entry var webViewCreateWebView: (WKWebViewConfiguration, WKNavigationAction, WKWindowFeatures) -> WKWebView? = { _, _, _ in nil }
    @Entry var webViewDidClose: () -> Void = { }
    @Entry var webViewDecideMediaCapturePermissionsForOrigin: (WKSecurityOrigin, WKFrameInfo, WKMediaCaptureType) async -> WKPermissionDecision = { _, _, _ in .prompt }
    @Entry var webViewRequestDeviceOrientationAndMotionPermissionForOrigin: (WKSecurityOrigin, WKFrameInfo) async -> WKPermissionDecision = { _, _ in  .prompt }
}

extension View {
    public func onWebViewCreateWebView(perform: @escaping (WKWebViewConfiguration, WKNavigationAction, WKWindowFeatures) -> WKWebView?) -> some View {
        environment(\.webViewCreateWebView, perform)
    }
    public func onWebViewDidClose(perform: @escaping () -> Void) -> some View {
        environment(\.webViewDidClose, perform)
    }
    public func onWebViewDecideMediaCapturePermissionsForOrigin(perform: @escaping (WKSecurityOrigin, WKFrameInfo, WKMediaCaptureType) async -> WKPermissionDecision) -> some View {
        environment(\.webViewDecideMediaCapturePermissionsForOrigin, perform)
    }
    public func onWebViewRequestDeviceOrientationAndMotionPermissionForOrigin(perform: @escaping (WKSecurityOrigin, WKFrameInfo) async -> WKPermissionDecision) -> some View {
        environment(\.webViewRequestDeviceOrientationAndMotionPermissionForOrigin, perform)
    }
}
