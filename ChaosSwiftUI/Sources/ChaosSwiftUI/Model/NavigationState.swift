//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 06.09.24.
//

import Combine
import SwiftUI

/**
 A wrapper for `NavigationPath` to enable `popTo(item:)` operations. At the same time it enables us to pass the
 navigation through `environmentObject`.
 */
//@MainActor
public class NavigationState: ObservableObject {

    /**
     The heterogenous navigation path used for a `NavigationStack` view.
     */
    @Published var path = NavigationPath()

    /**
     An array of boomarks to support `popTo(item:)` operations.

     Not all items that are pushed on the navigation path is bookmarked in order to keep the memory lean. Users have to
     explicitly specify, if they want to bookmark an item.
     */
    private var bookmarks: [Bookmark] = []
    
    /**
     The cancellable for the observation of the path.
     */
    private var cancellable: AnyCancellable?

    // MARK: NavigationPath forwarding properties

    public var count: Int {
        path.count
    }

    public var isEmpty: Bool {
        path.isEmpty
    }

    public var codable: NavigationPath.CodableRepresentation? {
        path.codable
    }

    public init() {
        cancellable = $path.receive(on: RunLoop.main)
            .sink { [weak self] path in
                guard let bookmark = self?.bookmarks.first,
                      bookmark.index > path.count else {
                    return
                }
                self?.updateBookmarks()
            }
    }

    /**
     Pushes an item onto the navigation path. Users can specify whether to bookmark the item or not. Bookmarks enables
     `NavigationState` to pop to an specific item with `popTo(item:).`
     - Parameters:
        - item: The item to push on top of the navigation path.
        - bookmark: Indicates whether to create a bookmark internally or not. Default's set to `false`
     */
    public func push<Item>(_ item: Item, bookmark: Bool = false) where Item: Hashable {
        path.append(item)
        if bookmark {
            bookmarks.append(Bookmark(index: count, item: item))
        }
    }

    /**
     Pops the first k elements from the top of the navigation path. Bookmarks will be removed accordingly.
     - Parameter k: Specifies how many elements to remove from the top of the navigation path.
     */
    public func pop(_ k: Int = 1) {
        path.removeLast(k)
    }

    /**
     Pops the first `count - index` elements from the top of the navigation path.
     - Parameter index: The index to which to pop until the corresponding element is the top element.
     */
    public func popTo(index: Int) {
        pop(path.count - index)
    }

    /**
     Pops all items from top to the specified `item` of the navigation path.
     - Parameter item: The first item from top to which to pop until it becomes the top element itself.
     */
    public func popTo<Item>(item: Item) where Item: Hashable {
        let item: AnyHashable = item
        guard let bookmark = bookmarks.last(where: { $0.item == item }) else {
            return
        }
        popTo(index: bookmark.index)
    }

    /**
     Pops all elements from the navigation path.
     */
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

extension NavigationState: Equatable {
    public static func == (lhs: NavigationState, rhs: NavigationState) -> Bool {
        lhs.path == rhs.path
    }
}
