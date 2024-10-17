//
//  Copyright © 2024 Fu Lam Diep <fulam.diep@gmail.com>
//

import SwiftUI

public struct TabBar<Selection, Content>: View where Selection: Hashable, Content: View {

    @Binding var selection: Selection?

    private let spacing: CGFloat

    private let content: () -> Content

    public init(selection: Binding<Selection?>, spacing: CGFloat = .zero, @ViewBuilder content: @escaping () -> Content) {
        self._selection = selection
        self.spacing = spacing
        self.content = content
    }

    public init<Data, Label>(
        _ data: Data,
        id: KeyPath<Data.Element, Selection>,
        selection: Binding<Selection?>,
        spacing: CGFloat = .zero,
        @ViewBuilder label: @escaping (Data.Element) -> Label
    ) where Data: RandomAccessCollection, Label: View, Content == ForEach<Data, Selection, Label> {
        self.init(selection: selection, spacing: spacing) {
            ForEach(data, id: id) { item in
                label(item)
            }
        }
    }

    public init<Data, Label>(
        _ data: Data,
        selection: Binding<Selection?>,
        spacing: CGFloat = .zero,
        @ViewBuilder label: @escaping (Data.Element) -> Label
    ) where Data: RandomAccessCollection, Data.Element: Identifiable, Data.Element.ID == Selection, Label: View, Content == ForEach<Data, Selection, Label> {
        self.init(selection: selection, spacing: spacing) {
            ForEach(data) { item in
                label(item)
            }
        }
    }

    public var body: some View {
        HStack(alignment: .bottom, spacing: spacing) {
            content()
        }
    }
}

extension LabelStyle where Self == GenericLabelStyle<AnyView> {
    static var tabBar: some LabelStyle {
        GenericLabelStyle { configuration in
            configuration.title
                .underline()
        }
    }
}

#Preview {
    TabBar(selection: .constant(0)) {
        Label("Test", image: "")
    }
    .labelStyle(.tabBar)
}
