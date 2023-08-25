//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 15.05.22.
//

import SwiftUI

public struct SegmentControl: View {

    public enum Label {
        case image(Image)
        case text(String)
        case both(Image, String)
    }

    public struct Item: Identifiable {
        public let id: String
        public let label: Label
    }

    @Binding private var selection: Int

    private let items: [Item]

    public init(selection: Binding<Int>, items: [Item]) {
        self._selection = selection
        self.items = items
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(items) { itemView($0) }
            }
        }
    }

    private func itemView(_ item: Item) -> some View {
        HStack {
            switch item.label {
            case .both(let image, let title):
                image
                Text(title)
            case .image(let image):
                image
            case .text(let title):
                Text(title)
            }
        }
    }
}
