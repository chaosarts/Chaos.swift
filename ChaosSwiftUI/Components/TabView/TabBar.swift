//
//  Copyright © 2024 Fu Lam Diep <fulam.diep@gmail.com>
//

import SwiftUI

public struct TabBar<Selection, Content>: View where Selection: Hashable, Content: View {

    @Binding var selection: Selection

    private let spacing: CGFloat

    private let content: () -> Content

    public init(selection: Binding<Selection>, spacing: CGFloat = 8, @ViewBuilder content: @escaping () -> Content) {
        self._selection = selection
        self.spacing = spacing
        self.content = content
    }

    public init<Data, Label>(
        _ data: Data,
        id: KeyPath<Data.Element, Selection>,
        selection: Binding<Selection>,
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
        selection: Binding<Selection>,
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

struct TabBarSelectionLabelStyle<Value>: LabelStyle {

    @EnvironmentObject var tabBarSelection: TabBarSelection<Value>

    func makeBody(configuration: Configuration) -> some View {
        configuration.title
    }
}

@available(iOS 17, *)
#Preview {
    @Previewable @State var selection: Int = 0
    TabBar(selection: $selection) {
        Label("Test", image: "")
        Label("Hallo", image: "")
    }
    .labelStyle(TabBarSelectionLabelStyle<Int>())
    .tabBarSelection($selection)
}
