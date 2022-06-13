//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 13.06.22.
//

import SwiftUI
import Combine

// MARK: - Basic Types

public enum ScrollEvent: Equatable {
    case scrollIdle
    case scrollBegin
    case scrollEnd
}

public struct ScrollEventPreferenceKey: PreferenceKey {

    public static var defaultValue: ScrollEvent = .scrollIdle

    public static func reduce(value: inout ScrollEvent, nextValue: () -> ScrollEvent) {
        value = nextValue()
    }
}

// MARK: - View Modifier

struct ScrollViewEventViewModifier: ViewModifier {

    @State var event: ScrollEvent = .scrollIdle

    let emitter: CurrentValueSubject<CGPoint, Never>

    let publisher: AnyPublisher<CGPoint, Never>

    init() {
        let emitter = CurrentValueSubject<CGPoint, Never>(.zero)
        self.emitter = emitter
        self.publisher = emitter.debounce(for: 0.2, scheduler: DispatchQueue.main)
            .dropFirst()
            .eraseToAnyPublisher()
    }

    func body(content: Content) -> some View {
        content.onPreferenceChange(OffsetPreferenceKey.self) { offset in
            emitter.send(offset)
            if event != .scrollBegin {
                event = .scrollBegin
            }
        }
        .onReceive(publisher) { _ in
            event = .scrollEnd
        }
        .preference(key: ScrollEventPreferenceKey.self, value: event)
    }
}

// MARK: - View Modifier

public extension View {
    func onScrollEvent(_ work: @escaping (ScrollEvent) -> Void) -> some View {
        modifier(ScrollViewEventViewModifier())
            .onPreferenceChange(ScrollEventPreferenceKey.self, perform: work)
    }

    func onScrollBegin(_ work: @escaping () -> Void) -> some View {
        onScrollEvent { event in
            if event == .scrollBegin {
                work()
            }
        }
    }

    func onScrollEnd(_ work: @escaping () -> Void) -> some View {
        onScrollEvent { event in
            if event == .scrollEnd {
                work()
            }
        }
    }
}
