//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 10.06.22.
//

import SwiftUI

struct TrackableScrollViewEventModifier: ViewModifier {

    var work: (TrackableScrollViewEvent) -> Void

    func body(content: Content) -> some View {
        content.onPreferenceChange(TrackableScrollViewEventKey.self) {
            work($0)
        }
    }
}

public extension View {

    func onScrollEvent(work: @escaping (TrackableScrollViewEvent) -> Void) -> some View {
        modifier(TrackableScrollViewEventModifier(work: { work($0) }))
    }

    func onScrollStart(_ work: @escaping () -> Void) -> some View {
        onScrollEvent {
            if case .scrollBegin = $0 {
                work()
            }
        }
    }

    func onScrollEnd(_ work: @escaping () -> Void) -> some View {
        onScrollEvent {
            if case .scrollEnd = $0 {
                work()
            }
        }
    }
}
