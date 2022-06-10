//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 10.06.22.
//

import SwiftUI

private struct TrackableScrollViewPreferenceKey: PreferenceKey {
    typealias Value = CGRect

    static var defaultValue: CGRect = .zero

    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {

    }
}

public struct TrackableScrollView<Content: View>: View {

    @Binding private var frame: CGRect

    private let axes: Axis.Set

    private let showsIndicators: Bool

    private let content: () -> Content

    public init(_ frame: Binding<CGRect> = .constant(.zero),
                axes: Axis.Set = .vertical,
                showsIndicators: Bool = true,
                @ViewBuilder content: @escaping () -> Content) {
        self._frame = frame
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.content = content
    }

    public var body: some View {
        ScrollView(axes, showsIndicators: showsIndicators) {
            content()
                .background {
                    GeometryReader { proxy in
                        let frame = proxy.frame(in: .named("scrollView"))
                        Color.clear.preference(key: TrackableScrollViewPreferenceKey.self, value: frame)
                    }
                }
        }
        .coordinateSpace(name: "scrollView")
        .onPreferenceChange(TrackableScrollViewPreferenceKey.self) { value in
            frame = value
        }
    }
}
