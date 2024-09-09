//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 06.09.24.
//

import SwiftUI

public class NavigationState: ObservableObject {
    @Published public var path = NavigationPath()

    private var anchors: [Anchor] = []

    public var count: Int { path.count }

    public init() {}

    public func push<Item>(_ item: Item, isAnchor: Bool = false) where Item: Hashable {
        path.append(item)
        if isAnchor {
            anchors.append(Anchor(item: item, index: path.count))
        }
    }

    public func pop(_ k: Int = 1) {
        path.removeLast(k)
        updateAnchors()
    }

    public func popTo(index: Int) {
        pop(path.count - index)
    }

    public func popTo<Item>(item: Item) where Item: Hashable {
        let item: AnyHashable = item
        guard let anchor = anchors.last(where: { $0.item == item }) else {
            return
        }
        popTo(index: anchor.index)
    }

    public func popToRoot() {
        pop(path.count)
    }

    private func updateAnchors() {
        anchors.removeAll { $0.index > path.count }
    }

    private struct Anchor {
        let item: AnyHashable
        let index: Int
    }
}
