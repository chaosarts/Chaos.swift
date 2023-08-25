//
//  Chart.swift
//  
//
//  Created by fu.lam.diep on 29.07.23.
//

import SwiftUI

public struct Chart<Content>: View where Content: ChartContent {

    @ChartContentBuilder public let content: Content

    public init(@ChartContentBuilder content: () -> Content) {
        self.content = content()
    }

    public init<Data, ID, C>(_ data: Data, id: KeyPath<Data.Element, ID>, @ChartContentBuilder content: @escaping (Data.Element) -> C)
    where Data: RandomAccessCollection, ID: Hashable, C: ChartContent, Content == For<Data, ID, C> {
        self.init {
            For(each: data, id: id, content: content)
        }
    }

    public init<Data, C>(_ data: Data, @ChartContentBuilder content: @escaping (Data.Element) -> C)
    where Data: RandomAccessCollection, Data.Element: Identifiable, C: ChartContent, Content == For<Data, Data.Element.ID, C> {
        self.init(data, id: \.id, content: content)
    }

    public init <ID, Collection, C>(_ data: Binding<Collection>, id: KeyPath<Collection.Element, ID>, @ChartContentBuilder content: @escaping (Binding<Collection.Element>) -> C) where Collection: MutableCollection & RandomAccessCollection, Collection.Index: Hashable, ID: Hashable, C:ChartContent, Content == For<LazyMapSequence<Collection.Indices, (Collection.Index, ID)>, ID, C> {
        self.init {
            For(each: data, id: id, content: content)
        }
    }

    public init <Collection, C>(_ data: Binding<Collection>, @ChartContentBuilder content: @escaping (Binding<Collection.Element>) -> C) where Collection: MutableCollection & RandomAccessCollection, Collection.Index: Hashable, Collection.Element: Identifiable, C:ChartContent, Content == For<LazyMapSequence<Collection.Indices, (Collection.Index, Collection.Element.ID)>, Collection.Element.ID, C> {
        self.init(data, id: \.id, content: content)
    }

    public var body: some View {
        Text("")
            .onAppear {
                print(content.isNever)
            }
    }
}
