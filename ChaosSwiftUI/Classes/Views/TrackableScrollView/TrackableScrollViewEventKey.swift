//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 10.06.22.
//

import SwiftUI

public struct TrackableScrollViewEventKey: PreferenceKey {

    public static var defaultValue: TrackableScrollViewEvent = .scrollIdle

    public static func reduce(value: inout TrackableScrollViewEvent, nextValue: () -> TrackableScrollViewEvent) {
        value = nextValue()
    }
}
