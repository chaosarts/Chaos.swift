//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 10.06.22.
//

import SwiftUI

struct TrackableScrollViewOffsetModifier: ViewModifier {

    var work: (CGPoint) -> Void

    func body(content: Content) -> some View {
        content.onPreferenceChange(TrackableScrollViewOffsetKey.self) { work($0) }
    }
}

public extension View {
    func onScrollChanged(_ work: @escaping (CGPoint) -> Void) -> some View {
        modifier(TrackableScrollViewOffsetModifier(work: work))
    }
}
