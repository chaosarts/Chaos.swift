//
//  Copyright © 2024 Fu Lam Diep <fulam.diep@gmail.com>
//

import SwiftUI

public protocol CarouselView: View {
    associatedtype Content: View
    init(alignment: VerticalAlignment, spacing: CGFloat, @ViewBuilder content: @escaping () -> Content)
}


extension CarouselView {

    public init(alignment: VerticalAlignment, @ViewBuilder content: @escaping () -> Content) {
        self.init(alignment: alignment, spacing: 0, content: content)
    }

    public init(spacing: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.init(alignment: .top, spacing: spacing, content: content)
    }

    public init<Data, ID, Item>(
        _ data: Data,
        id: KeyPath<Data.Element, ID>,
        alignment: VerticalAlignment = .top,
        spacing: CGFloat = 0,
        @ViewBuilder item: @escaping (Data.Element) -> Item
    ) where Data: RandomAccessCollection, ID: Hashable, Item: View, Content == ForEach<Data, ID, Item> {
        self.init(alignment: alignment, spacing: spacing) {
            ForEach(data, id: id) { element in
                item(element)
            }
        }
    }

    public init<Data, Item>(
        _ data: Data,
        alignment: VerticalAlignment = .top,
        spacing: CGFloat = 0,
        @ViewBuilder item: @escaping (Data.Element) -> Item
    ) where Data: RandomAccessCollection, Data.Element: Identifiable, Item: View, Content == ForEach<Data, Data.Element.ID, Item> {
        self.init(alignment: alignment, spacing: spacing) {
            ForEach(data, id: \.id) { element in
                item(element)
            }
        }
    }

    public init<Data, ID, Item>(
        _ data: Binding<Data>,
        id: KeyPath<Binding<Data>.Element, ID>,
        alignment: VerticalAlignment = .top,
        spacing: CGFloat = 0,
        @ViewBuilder item: @escaping (Binding<Data.Element>) -> Item
    ) where Data: RandomAccessCollection, ID: Hashable, Item: View, Content == ForEach<Binding<Data>, ID, Item> {
        self.init(alignment: alignment, spacing: spacing) {
            ForEach(data, id: id) { element in
                item(element)
            }
        }
    }

    public init<Data, Item>(
        _ data: Binding<Data>,
        alignment: VerticalAlignment = .top,
        spacing: CGFloat = 0,
        @ViewBuilder item: @escaping (Binding<Data.Element>) -> Item
    ) where Data: RandomAccessCollection, Data.Element: Identifiable, Item: View, Content == ForEach<Binding<Data>, Data.Element.ID, Item> {
        self.init(alignment: alignment, spacing: spacing) {
            ForEach(data, id: \.id) { element in
                item(element)
            }
        }
    }
}
