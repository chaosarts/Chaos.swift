//
//  Copyright © 2024 Fu Lam Diep <fulam.diep@gmail.com>
//

import SwiftUI
import WebKit

public typealias WebViewScriptHandler = (WKScriptMessage) -> Void
public typealias WebViewScriptHandlerWithReply = (WKScriptMessage) async -> (Any?, String?)

extension EnvironmentValues {
    @Entry var scriptMessageHandlers: [String: WebViewScriptHandler] = [:]
    @Entry var scriptMessageHandlersWithReply: [String: WebViewScriptHandlerWithReply] = [:]
}

fileprivate struct ScriptMessageHandlerModifier: ViewModifier {
    @Environment(\.scriptMessageHandlers) var handlers

    var newHandlers: [String: WebViewScriptHandler] {
        var handlers = handlers
        handlers[name] = action
        return handlers
    }

    let name: String

    let action: WebViewScriptHandler

    func body(content: Content) -> some View {
        content.environment(\.scriptMessageHandlers, newHandlers)
    }
}

fileprivate struct ScriptMessageHandlerWithReplyModifier: ViewModifier {
    @Environment(\.scriptMessageHandlersWithReply) var handlers

    var newHandlers: [String: WebViewScriptHandlerWithReply] {
        var handlers = handlers
        handlers[name] = action
        return handlers
    }

    let name: String

    let action: WebViewScriptHandlerWithReply

    func body(content: Content) -> some View {
        content.environment(\.scriptMessageHandlersWithReply, newHandlers)
    }
}

extension View {
    public func onWebViewScriptMessage(_ name: String, perform: @escaping WebViewScriptHandler) -> some View {
        modifier(ScriptMessageHandlerModifier(name: name, action: perform))
    }

    public func onWebViewScriptMessage(_ name: String, perform: @escaping WebViewScriptHandlerWithReply) -> some View {
        modifier(ScriptMessageHandlerWithReplyModifier(name: name, action: perform))
    }
}
