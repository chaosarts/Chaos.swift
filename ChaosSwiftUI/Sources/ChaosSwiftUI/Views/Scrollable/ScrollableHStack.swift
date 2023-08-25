//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 10.06.22.
//

import SwiftUI
import Combine

public struct ScrollableHStack<Content: View>: View {

    private let alignment: VerticalAlignment

    private let spacing: CGFloat?

    private let edgeInsets: EdgeInsets

    private let content: () -> Content

    private let lazy: Bool

    public init(lazy: Bool = false,
                alignment: VerticalAlignment = .center,
                spacing: CGFloat?,
                edgeInsets: EdgeInsets = .zero,
                @ViewBuilder _ content: @escaping () -> Content) {
        self.lazy = lazy
        self.alignment = alignment
        self.spacing = spacing
        self.edgeInsets = edgeInsets
        self.content = content
    }

    public var body: some View {
        ScrollView {
            OffsetReader { _ in
                if lazy {
                    LazyHStack(alignment: alignment, spacing: spacing, content: content)
                } else {
                    HStack(alignment: alignment, spacing: spacing, content: content)
                }
            }
        }
        .padding(edgeInsets)
    }
}
