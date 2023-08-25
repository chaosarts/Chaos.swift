//
//  File.swift
//  
//
//  Created by fu.lam.diep on 01.07.23.
//

import SwiftUI

public struct TocView<Content: View>: View {

    @State private var items: [TocItem] = []

    private let content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        ScrollView {
            ScrollViewReader { scrollViewProxy in
                VStack {
                    ItemTabBar(items, scrollViewProxy: scrollViewProxy)
                    content()
                }
            }
        }
        .onPreferenceChange(TocItemPreferenceKey.self) { items in
            self.items = items
        }
    }

    private func ItemTabBar(_ items: [TocItem], scrollViewProxy: ScrollViewProxy) -> some View {
        HStack(alignment: .center, spacing: 8) {
            ForEach(items) { item in
                Button(item.title) {
                    scrollViewProxy.scrollTo(item.hash)
                }
            }
        }
    }
}

struct TocView_Preview: PreviewProvider {
    static var previews: some View {
        TocView {
            Text("Hallo Welt").tocItem("Hallo")
                .frame(height: 400)

            Text("Hallo Welt").tocItem("Welt")
                .frame(height: 400)

            Text("Du").tocItem("Du")
                .frame(height: 400)
        }
        .frame(maxWidth: .infinity)
    }
}
