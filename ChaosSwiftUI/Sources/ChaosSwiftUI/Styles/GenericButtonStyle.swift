//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 31.08.24.
//

import SwiftUI

public struct GenericButtonStyle<Content>: ButtonStyle where Content: View {

    @Environment(\.isEnabled) var isEnabled

    @Environment(\.isBusy) var isBusy

    private var isDisabled: Bool {
        !isEnabled || isBusy
    }

    private let content: (Configuration, _ isEnabled: Bool, _ isBusy: Bool) -> Content

    public init(@ViewBuilder _ content: @escaping (Configuration, _ isEnabled: Bool, _ isBusy: Bool) -> Content) {
        self.content = content
    }

    public func makeBody(configuration: Configuration) -> some View {
        content(configuration, isEnabled, isBusy)
    }
}
