//
//  ModalViewModifier.swift
//  SwiftUIExamples
//
//  Created by Fu Lam Diep on 03.03.22.
//

import SwiftUI

public struct ModalViewModifier<C: View>: ViewModifier {

    private let modalViewPresenter: ModalViewPresenter<C>

    public init(isPresented: Binding<Bool>,
                color: Color = .black.opacity(0.2),
                dismissesByBackground: Bool = true,
                content: @escaping () -> C) {
        modalViewPresenter = ModalViewPresenter(isPresented: isPresented,
                                                dismissesByBackground: dismissesByBackground,
                                                color: color,
                                                content: content)
    }

    public func body(content: Content) -> some View {
        ZStack {
            modalViewPresenter
            content
        }
    }
}

public extension View {
    func modal<Content: View>(isPresented: Binding<Bool>,
                              color: Color = .black.opacity(0.2),
                              dismissesByBackground: Bool = true,
                              content: @escaping () -> Content) -> some View {
        modifier(ModalViewModifier(isPresented: isPresented,
                                   color: color,
                                   dismissesByBackground: dismissesByBackground,
                                   content: content))
    }
}
