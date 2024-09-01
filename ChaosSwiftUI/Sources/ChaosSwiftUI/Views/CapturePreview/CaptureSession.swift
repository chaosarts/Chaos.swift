//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 23.08.24.
//

import SwiftUI

public struct CaptureSession<Proxy, Content>: View where Proxy: CaptureSessionProxy, Content: View {

    @StateObject private var proxy: Proxy = Proxy()

    private let content: (Proxy) -> Content

    public init(content: @escaping (Proxy) -> Content) {
        self.content = content
    }

    public var body: some View {
        content(proxy)
    }
}
