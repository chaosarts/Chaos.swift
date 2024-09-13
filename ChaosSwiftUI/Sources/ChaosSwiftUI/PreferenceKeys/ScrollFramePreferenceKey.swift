//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 23.08.24.
//

import SwiftUI

struct ScrollFramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect { .zero }

    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

extension View {
    public func onScrollFrameChange(perform: @escaping (CGRect) -> Void) -> some View {
        onPreferenceChange(ScrollFramePreferenceKey.self) { frame in
            perform(frame)
        }
    }

    func scrollFramePreference(_ frame: CGRect) -> some View {
        preference(key: ScrollFramePreferenceKey.self, value: frame)
    }

    public func scrollTracking(coordinateSpace: CoordinateSpace = .global) -> some View {
        overlay {
            GeometryReader { proxy in
                Color.clear.scrollFramePreference(proxy.frame(in: coordinateSpace))
            }
        }
    }
}
