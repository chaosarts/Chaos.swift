//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 10.06.22.
//

import SwiftUI
import Combine

public struct TrackableScrollView<Content: View>: View {

    @State private var event: TrackableScrollViewEvent = .scrollIdle

    private let axes: Axis.Set

    private let showsIndicators: Bool

    private let content: () -> Content

    private let emitter: CurrentValueSubject<CGPoint, Never>

    private let publisher: AnyPublisher<CGPoint, Never>

    public init(axes: Axis.Set = .vertical,
                showsIndicators: Bool = true,
                @ViewBuilder content: @escaping () -> Content) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.content = content

        let emitter = CurrentValueSubject<CGPoint, Never>(.zero)
        self.emitter = emitter
        self.publisher = emitter
            .debounce(for: 0.2, scheduler: DispatchQueue.main)
            .dropFirst()
            .eraseToAnyPublisher()
    }

    public var body: some View {
        ScrollView(axes, showsIndicators: showsIndicators) {
            content()
                .background {
                    GeometryReader { proxy in
                        let offset = proxy.frame(in: .named("scrollView")).origin
                        Color.clear.preference(key: TrackableScrollViewOffsetKey.self, value: offset)
                    }
                }
        }
        .coordinateSpace(name: "scrollView")
        .onPreferenceChange(TrackableScrollViewOffsetKey.self) { value in
            emitter.send(value)
            if event != .scrollBegin {
                event = .scrollBegin
            }
        }
        .onReceive(publisher) { _ in
            event = .scrollEnd
        }
        .preference(key: TrackableScrollViewEventKey.self, value: event)
    }
}
