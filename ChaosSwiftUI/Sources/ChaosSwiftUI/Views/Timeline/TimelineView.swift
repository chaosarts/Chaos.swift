//
//  File.swift
//  
//
//  Created by fu.lam.diep on 26.11.22.
//

import SwiftUI

public struct TimelineView<Element: Any, ID: Hashable, MilestoneView: View>: View {

    @Binding
    private var elements: [Element]

    private let keyPath: KeyPath<Element, ID>

    private let milestones: (Element) -> MilestoneView

    public init(_ elements: Binding<[Element]>, keyPath: KeyPath<Element, ID>, @ViewBuilder milestones: @escaping (Element) -> MilestoneView) {
        self._elements = elements
        self.keyPath = keyPath
        self.milestones = milestones
    }

    public var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ForEach(elements, id: keyPath) { element in
                milestones(element)
            }
        }
    }
}
