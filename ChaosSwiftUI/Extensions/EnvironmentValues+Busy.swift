//
//  ButtonEnvironmentKey.swift
//
//  Created by Fu Lam Diep on 31.08.24.
//

import SwiftUI

fileprivate struct BusyViewModifier: ViewModifier {

    @Environment(\.isEnabled) var isEnabled

    let value: Bool

    init(_ value: Bool) {
        self.value = value
    }

    func body(content: Content) -> some View {
        content.disabled(!isEnabled || value)
            .environment(\.isBusy, value)
    }
}

extension EnvironmentValues {
    @Entry public fileprivate(set) var isBusy: Bool = false
}

extension View {
    public func busy(_ value: Bool = true) -> some View {
        modifier(BusyViewModifier(value))
    }
}
