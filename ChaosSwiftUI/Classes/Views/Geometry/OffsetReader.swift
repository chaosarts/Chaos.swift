//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 13.06.22.
//

import SwiftUI

public struct OffsetReader<Content: View>: View {

    @State private var offset: CGPoint = .zero

    private let coordinateSpace: CoordinateSpace

    private let content: (CGPoint) -> Content

    public init(coordinateSpaceName: AnyHashable? = nil, @ViewBuilder content: @escaping (CGPoint) -> Content) {
        let coordinateSpace: CoordinateSpace
        if let coordinateSpaceName = coordinateSpaceName {
            coordinateSpace = .named(coordinateSpaceName)
        } else {
            coordinateSpace = .global
        }

        self.coordinateSpace = coordinateSpace
        self.content = content
    }

    public var body: some View {
        Group {
            content(offset)
        }
        .background {
            GeometryReader { proxy in
                let offset = proxy.frame(in: coordinateSpace).origin
                Color.clear.preference(key: OffsetPreferenceKey.self, value: offset)
            }
        }
        .onPreferenceChange(OffsetPreferenceKey.self) { offset in
            self.offset = offset
        }
    }
}

struct OffsetPreferenceKey: PreferenceKey {

    static var defaultValue: CGPoint = .zero

    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        value = nextValue()
    }
}

public extension View {
    func onOffsetChanged(coordinateSpaceName: AnyHashable? = nil, work: @escaping (CGPoint) -> Void) -> some View {
        coordinateSpace(name: coordinateSpaceName)
            .onPreferenceChange(OffsetPreferenceKey.self, perform: work)
    }
}
