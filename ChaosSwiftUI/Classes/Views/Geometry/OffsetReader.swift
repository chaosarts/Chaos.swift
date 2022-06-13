//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 13.06.22.
//

import SwiftUI

/// An internal preference key to publishe changes in the offset of a view.
struct OffsetPreferenceKey: PreferenceKey {

    static var defaultValue: CGPoint = .zero

    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        value = nextValue()
    }
}

/// A view that wraps a content in order to get information about the offset changes within the parent view. This View
/// is primarily as direct child for scroll views.
public struct OffsetReader<Content: View>: View {

    /// Holds the offset to publish on changes
    @State private var offset: CGPoint = .zero

    /// Provides the coordinate space, which the parent view specified with `.coordinateSpace(name:)`
    private let coordinateSpace: CoordinateSpace

    /// The content to display within the reader.
    private let content: (CGPoint) -> Content

    /// Creates a new OffsetReader with a specified content view.
    ///
    /// When specifiying a coordinate space name, one should
    /// specifiy the same name as the parent view (primarily `ScrollView`) sepcifies through `.coordinateSpace(name:)`.
    /// If no coordinate space is specified, the reader uses the `.global` coordinate space.
    ///
    /// - Parameter coordinateSpaceName: The name of the coordinate space, which is specified by the parent view.
    /// - Parameter content: The content to display inside the reader.
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


// MARK: - Extension for offset change

public extension View {
    func onOffsetChanged(coordinateSpaceName: AnyHashable? = nil, work: @escaping (CGPoint) -> Void) -> some View {
        coordinateSpace(name: coordinateSpaceName)
            .onPreferenceChange(OffsetPreferenceKey.self, perform: work)
    }
}
