//
//  Copyright © 2024 Fu Lam Diep <fulam.diep@gmail.com>
//

import ChaosNet
import SwiftUI
import WebKit

public struct WebView: UIViewRepresentable {

    public typealias Configuration = WKWebViewConfiguration

    private let navigator: Navigator

    private let configuration: Configuration

    public init(navigator: Navigator, configuration: Configuration = .init()) {
        self.navigator = navigator
        self.configuration = configuration
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    public func makeUIView(context: Context) -> WKWebView {
        let wkWebView = WKWebView()
        navigator.wkWebView = wkWebView
        wkWebView.navigationDelegate = context.coordinator
        wkWebView.uiDelegate = context.coordinator
        context.coordinator.environment = context.environment
        return wkWebView
    }

    public func updateUIView(_ wkWebView: WKWebView, context: Context) {
        context.coordinator.environment = context.environment
        for (name, _) in context.environment.scriptMessageHandlers {
            wkWebView.configuration.userContentController.add(context.coordinator, name: name)
        }

        for (name, _) in context.environment.scriptMessageHandlersWithReply {
            wkWebView.configuration.userContentController.addScriptMessageHandler(context.coordinator, contentWorld: WKContentWorld.defaultClient, name: name)
        }
    }
}

extension WebView {
    public class Navigator {
        fileprivate weak var wkWebView: WKWebView? {
            willSet {
                if wkWebView != nil {
                    fatalError("Navigator already assigned to another WebView.")
                }
            }
        }

        public var title: String? {
            wkWebView?.title
        }

        public var url: URL? {
            wkWebView?.url
        }

        public var isLoading: Bool {
            wkWebView?.isLoading ?? false
        }

        public var estimatedProgress: Double {
            wkWebView?.estimatedProgress ?? 0
        }

        public var  hasOnlySecureContent: Bool {
            wkWebView?.hasOnlySecureContent ?? false
        }

        public var backForwardList: WKBackForwardList {
            wkWebView?.backForwardList ?? WKBackForwardList()
        }

        public var canGoBack: Bool {
            wkWebView?.canGoBack ?? false
        }

        public var canGoForward: Bool {
            wkWebView?.canGoForward ?? false
        }

        public var allowsBackForwardNavigationGestures: Bool {
            get { wkWebView?.allowsBackForwardNavigationGestures ?? false }
            set { wkWebView?.allowsBackForwardNavigationGestures = newValue }
        }

        public var allowsLinkPreview: Bool {
            get { wkWebView?.allowsLinkPreview ?? false }
            set { wkWebView?.allowsLinkPreview = newValue }
        }

        @available(iOS 16.4, *)
        public var isInspectable: Bool {
            get { wkWebView?.isInspectable ?? false }
            set { wkWebView?.isInspectable = newValue }
        }

        public init() {}

        @discardableResult
        public func load(_ request: URLRequest) -> WKNavigation? {
            wkWebView?.load(request)
        }

        @discardableResult
        public func load(
            _ url: URL,
            cachePolicy: URLRequest.CachePolicy = URLSessionConfiguration.default.requestCachePolicy,
            timeout: TimeInterval = URLSessionConfiguration.default.timeoutIntervalForRequest
        ) -> WKNavigation? {
            let request = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeout)
            return wkWebView?.load(request)
        }

        @discardableResult
        public func load(
            _ data: Data,
            mimeType: MimeType = .text("html"),
            encoding: String.Encoding = .utf8,
            baseURL: URL
        ) -> WKNavigation? {
            wkWebView?.load(data, mimeType: mimeType.description, characterEncodingName: encoding.htmlCharacterSet, baseURL: baseURL)
        }

        public func loadHTMLString(_ string: String, baseURL: URL? = nil) -> WKNavigation? {
            wkWebView?.loadHTMLString(string, baseURL: baseURL)
        }

        @discardableResult
        public func go(to item: WKBackForwardListItem) -> WKNavigation? {
            wkWebView?.go(to: item)
        }

        @discardableResult
        public func goBack() -> WKNavigation? {
            wkWebView?.goBack()
        }

        @discardableResult
        public func goForward() -> WKNavigation? {
            wkWebView?.goForward()
        }

        @discardableResult
        public func reload() -> WKNavigation? {
            wkWebView?.reload()
        }

        public func stopLoading() {
            wkWebView?.stopLoading()
        }
    }

    public class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler, WKScriptMessageHandlerWithReply {

        fileprivate var environment: EnvironmentValues!

        public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences) async -> (WKNavigationActionPolicy, WKWebpagePreferences) {
            await environment.webViewDecidePolicyForNavigationAction(navigationAction, preferences)
        }

        public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse) async -> WKNavigationResponsePolicy {
            await environment.webViewDecidePolicyForNavigationResponse(navigationResponse)
        }

        public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            environment.webViewDidStartProvisionalNavigation(navigation)
        }

        public func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
            environment.webViewDidReceiveServerRedirectForProvisionalNavigation(navigation)
        }

        public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: any Error) {
            environment.webViewDidFailProvisionalNavigation(navigation, error)
        }

        public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            environment.webViewDidCommitNavigation(navigation)
        }

        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            environment.webViewDidFinishNavigation(navigation)
        }

        public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: any Error) {
            environment.webViewDidFailNavigation(navigation, error)
        }

        public func webView(_ webView: WKWebView, respondTo challenge: URLAuthenticationChallenge) async -> (URLSession.AuthChallengeDisposition, URLCredential?) {
            await environment.webViewRespondToChallenge(challenge)
        }

        public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
            environment.webViewWebContentProcessDidTerminate()
        }

        public func webView(_ webView: WKWebView, shouldAllowDeprecatedTLSFor challenge: URLAuthenticationChallenge) async -> Bool {
            await environment.webViewAuthenticationChallenge(challenge)
        }

        public func webView(_ webView: WKWebView, navigationAction: WKNavigationAction, didBecome download: WKDownload) {
            environment.webViewNavigationActionDidBecomeDownload(navigationAction, download)
        }

        public func webView(_ webView: WKWebView, navigationResponse: WKNavigationResponse, didBecome download: WKDownload) {
            environment.webViewNavigationResponseDidBecomeDownload(navigationResponse, download)
        }

        public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            environment.scriptMessageHandlers[message.name]?(message)
        }

        public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) async -> (Any?, String?) {
            await environment.scriptMessageHandlersWithReply[message.name]?(message) ?? (nil, nil)
        }
    }
}
