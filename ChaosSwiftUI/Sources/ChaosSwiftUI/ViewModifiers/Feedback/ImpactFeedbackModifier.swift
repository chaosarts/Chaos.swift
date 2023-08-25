//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 15.04.22.
//

import SwiftUI

public struct ImpactFeedbackModifier: ViewModifier {

    public typealias Style = UIImpactFeedbackGenerator.FeedbackStyle

    public enum Event {
        case onTap
        case onAppear
    }

    private let generator: UIImpactFeedbackGenerator

    private let event: Event

    private let intensity: CGFloat

    public init(style: Style, event: Event = .onTap, intensity: CGFloat = 1) {
        self.generator = UIImpactFeedbackGenerator(style: style)
        self.event = event
        self.intensity = intensity
    }

    public func body(content: Content) -> some View {
        switch event {
        case .onTap:
            return AnyView(content.onTapGesture {
                generator.impactOccurred(intensity: intensity)
            })
        case .onAppear:
            return AnyView(content.onAppear {
                generator.impactOccurred(intensity: intensity)
            })
        }
    }
}

public extension View {
    func impactFeedback(style: ImpactFeedbackModifier.Style, event: ImpactFeedbackModifier.Event = .onTap, intensity: CGFloat = 1) -> some View {
        modifier(ImpactFeedbackModifier(style: style, event: event, intensity: intensity))
    }
}
