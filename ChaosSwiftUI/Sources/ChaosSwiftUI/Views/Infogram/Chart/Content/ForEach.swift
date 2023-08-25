//
//  File.swift
//  
//
//  Created by fu.lam.diep on 29.07.23.
//

import SwiftUI

public struct For<Data, ID, Content> where Data: RandomAccessCollection, ID: Hashable {
    public var data: Data
    public var id: KeyPath<Data.Element, ID>
    public var content: (Data.Element) -> Content

    fileprivate init(data: Data, id: KeyPath<Data.Element, ID>, content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.id = id
        self.content = content
    }
}

extension For where Data.Element: Identifiable, Data.Element.ID == ID {
    fileprivate init(data: Data, content: @escaping (Data.Element) -> Content) {
        self.init(data: data, id: \.id, content: content)
    }
}

extension For: ChartContent where Content: ChartContent {
    public typealias Body = Never
}

extension For where Content: ChartContent {
    public init(each data: Data, id: KeyPath<Data.Element, ID>, @ChartContentBuilder content: @escaping (Data.Element) -> Content) {
        self.init(data: data, id: id, content: content)
    }
}

extension For where Content: ChartContent, Data.Element: Identifiable, Data.Element.ID == ID {
    public init(each data: Data, @ChartContentBuilder content: @escaping (Data.Element) -> Content) {
        self.init(each: data, id: \.id, content: content)
    }
}

extension For where Content: ChartContent {
    public init<C>(each data: Binding<C>, id: KeyPath<C.Element, ID>, @ChartContentBuilder content: @escaping (Binding<C.Element>) -> Content)
    where C: RandomAccessCollection & MutableCollection, C.Index: Hashable, Data == LazyMapSequence<C.Indices, (C.Index, ID)> {
        let sequence = data.indices.lazy.map { element in
            (element, data.wrappedValue[element][keyPath: id])
        }

        self.init(data: sequence, id: \.1, content: { element in
            content(data[element.0])
        })
    }
}
