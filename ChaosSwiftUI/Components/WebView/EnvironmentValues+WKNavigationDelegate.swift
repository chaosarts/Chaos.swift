//
//  Copyright © 2024 Fu Lam Diep <fulam.diep@gmail.com>
//

import SwiftUI
import WebKit

extension EnvironmentValues {
    @Entry var webViewDecidePolicyForNavigationAction: (WKNavigationAction, WKWebpagePreferences) async -> (WKNavigationActionPolicy, WKWebpagePreferences) = { (.allow, $1) }
    @Entry var webViewDecidePolicyForNavigationResponse: (WKNavigationResponse) async -> WKNavigationResponsePolicy = { _ in .allow }
    @Entry var webViewDidStartProvisionalNavigation: (WKNavigation?) -> Void = { _ in }
    @Entry var webViewDidReceiveServerRedirectForProvisionalNavigation: (WKNavigation?) -> Void = { _ in }
    @Entry var webViewDidFailProvisionalNavigation: (WKNavigation?, Error) -> Void = { _, _ in }
    @Entry var webViewDidCommitNavigation: (WKNavigation?) -> Void = { _ in }
    @Entry var webViewDidFinishNavigation: (WKNavigation?) -> Void = { _ in }
    @Entry var webViewDidFailNavigation: (WKNavigation?, Error) -> Void = { _, _ in }
    @Entry var webViewRespondToChallenge: (URLAuthenticationChallenge) async -> (URLSession.AuthChallengeDisposition, URLCredential?) = { _ in (.performDefaultHandling ,nil) }
    @Entry var webViewWebContentProcessDidTerminate: () -> Void = { }
    @Entry var webViewAuthenticationChallenge: (URLAuthenticationChallenge) async -> Bool = { _ in false }
    @Entry var webViewNavigationActionDidBecomeDownload: (WKNavigationAction, WKDownload) -> Void = { _, _ in }
    @Entry var webViewNavigationResponseDidBecomeDownload: (WKNavigationResponse, WKDownload) -> Void = { _, _ in }
}

extension View {
    public func policyForNavigationAction(perform: @escaping (WKNavigationAction, WKWebpagePreferences) async -> (WKNavigationActionPolicy, WKWebpagePreferences)) -> some View {
        environment(\.webViewDecidePolicyForNavigationAction, perform)
    }

    public func policyForNavigationResponse(perform: @escaping (WKNavigationResponse) async -> WKNavigationResponsePolicy) -> some View {
        environment(\.webViewDecidePolicyForNavigationResponse, perform)
    }

    public func onStartProvisionalNavigation(perform: @escaping (WKNavigation?) -> Void) -> some View {
        environment(\.webViewDidStartProvisionalNavigation, perform)
    }

    public func onReceiveServerRedirectForProvisionalNavigation(perform: @escaping (WKNavigation?) -> Void) -> some View {
        environment(\.webViewDidReceiveServerRedirectForProvisionalNavigation, perform)
    }

    public func onFailProvisionalNavigation(perform: @escaping (WKNavigation?, Error) -> Void) -> some View {
        environment(\.webViewDidFailProvisionalNavigation, perform)
    }

    public func onCommitNavigation(perform: @escaping (WKNavigation?) -> Void) -> some View {
        environment(\.webViewDidCommitNavigation, perform)
    }

    public func onFinishNavigation(perform: @escaping (WKNavigation?) -> Void) -> some View {
        environment(\.webViewDidFinishNavigation, perform)
    }

    public func onFailNavigation(perform: @escaping (WKNavigation?, Error) -> Void) -> some View {
        environment(\.webViewDidFailNavigation, perform)
    }

    public func respondToChallenge(perform: @escaping (URLAuthenticationChallenge) async -> (URLSession.AuthChallengeDisposition, URLCredential?)) -> some View {
        environment(\.webViewRespondToChallenge, perform)
    }

    public func onWebContentProcessTerminate(perform: @escaping () -> Void) -> some View {
        environment(\.webViewWebContentProcessDidTerminate, perform)
    }

    public func authenticationChallenge(perform: @escaping (URLAuthenticationChallenge) async -> Bool) -> some View {
        environment(\.webViewAuthenticationChallenge, perform)
    }

    public func onNavigationActionBecomeDownload(perform: @escaping (WKNavigationAction, WKDownload) -> Void) -> some View {
        environment(\.webViewNavigationActionDidBecomeDownload, perform)
    }

    public func onNavigationResponseBecomeDownload(perform: @escaping (WKNavigationResponse, WKDownload) -> Void) -> some View {
        environment(\.webViewNavigationResponseDidBecomeDownload, perform)
    }
}
