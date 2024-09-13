//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 06.09.24.
//

import SwiftUI

public class NavigationState: ObservableObject {
    @Published var path = NavigationPath()

    private var bookmarks: [Bookmark] = []

    public var count: Int { path.count }

    public init() {}

    public func push<Item>(_ item: Item, bookmark: Bool = false) where Item: Hashable {
        path.append(item)
        if bookmark {
            bookmarks.append(Bookmark(index: count, item: item))
        }
    }

    public func pop(_ k: Int = 1) {
        path.removeLast(k)
        updateBookmarks()
    }

    public func popTo(index: Int) {
        pop(path.count - index)
    }

    public func popTo<Item>(item: Item) where Item: Hashable {
        let item: AnyHashable = item
        guard let bookmark = bookmarks.last(where: { $0.item == item }) else {
            return
        }
        popTo(index: bookmark.index)
    }

    public func popToRoot() {
        pop(path.count)
    }

    private func updateBookmarks() {
        bookmarks.removeAll { $0.index >= count }
    }
}

extension NavigationState {
    private struct Bookmark: Equatable {
        let index: Int
        let item: AnyHashable
    }
}

public struct ChaosNavigationStack<Root>: View where Root: View {
    
    @ObservedObject var navigationState: NavigationState

    private let root: () -> Root

    public init(navigationState: NavigationState, @ViewBuilder root: @escaping () -> Root) {
        self.navigationState = navigationState
        self.root = root
    }

    public var body: some View {
        NavigationStack(path: $navigationState.path, root: root)
            .environmentObject(navigationState)
    }
}
