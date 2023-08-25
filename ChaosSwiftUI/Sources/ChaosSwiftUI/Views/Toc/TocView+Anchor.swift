//
//  File.swift
//  
//
//  Created by fu.lam.diep on 01.07.23.
//

import SwiftUI

public struct TocItem: Equatable, Identifiable {
    public var id: AnyHashable { hash }
    public let title: String
    public let hash: AnyHashable

    public init(_ title: String, hash: AnyHashable) {
        self.title = title
        self.hash = hash
    }
}

internal struct TocItemPreferenceKey: PreferenceKey {
    static var defaultValue: [TocItem] { [] }

    static func reduce(value: inout [TocItem], nextValue: () -> [TocItem]) {
        value += nextValue()
    }
}

public struct TocItemView: View {
    private let item: TocItem

    public init(_ item: TocItem) {
        self.item = item
    }

    public init(_ title: String, hash: AnyHashable) {
        self.init(TocItem(title, hash: hash))
    }

    public var body: some View {
        Color.red.id(item.hash)
            .preference(key: TocItemPreferenceKey.self, value: [item])
    }
}

extension View {
    public func tocItem(_ title: String, hash: AnyHashable? = nil) -> some View {
        ZStack(alignment: .top) {
            TocItemView(title, hash: hash ?? (title as AnyHashable))
            self
        }
    }
}


