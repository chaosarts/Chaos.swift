//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 10.06.22.
//

import SwiftUI

struct TrackableScrollViewOffsetKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero

    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        value = nextValue()
    }
}
