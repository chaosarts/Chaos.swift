//
//  Carousel.swift
//
//  Created by Fu Lam Diep on 21.07.24.
//

import SwiftUI

/**
 A view that arranges its children in a scrollable horizontal stack.
 
 The api of this view is similar to SwiftUI's `List`. You can either specifiy the elements arbitrary or you pass a data
 collection to the initializer and specify a view builder that builds a element view for each element of the collection.
 
 ```swift
 // Carousel with arbitrary element views
 Carsouel(alignment: .top, spacing: 8) {
    // First carousel element
    Text("Hello")
    // Second carousel element
    Button("World") {
        ...
    }
 }
 
 // Carousel with data collection
 Carsouel([0..<10], id: \.self) { number in
    Text("\(number)")
 }
 ```
 
 Like `List` you can also pass a `Binding` of data collection. Use this initializer, when elements of your data
 collection provides mutable properties, that you need to pass as `Binding` to your element subview.
 
 ```swift
 Carousel($checkboxes) { checkbox in
    Toggle(checkbox.wrappedValue.title, isOn: checkBox.isOn)
 }
 ```
 */
public struct Carousel<Content>: View where Content: View {
    
    /**
     Provides the vertical alignment of the elements within the carousel.
     
     This will value will be forwarded to the internal `HStack`.
     */
    private let alignment: VerticalAlignment
    
    /**
     Provides the horizontal spacing between the top level elements of the carousel.
     
     This will value will be forwarded to the internal `HStack`.
     */
    private let spacing: CGFloat
    
    /**
     Provides the view builder closure to build one or more top level elements of the carousel.
     */
    private let content: () -> Content

    private let coordinateSpaceName: String = "ChaosSwiftUI.Carousel"

    /**
     Initializes the carousel, where elements may be arbitrary.
     */
    public init(alignment: VerticalAlignment = .top, spacing: CGFloat = 0, content: @escaping () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content
    }
    
    /**
     Initializes the carousel with a collection of data and a view builder, that returns a view for eacht element of the
     collection.
     
     Use this initializer, when your collection (at max) can change as whole. If your elements provides properties, that
     require to mutate, use the initializer with data binding.
     */
    public init<Data, ID, Item>(_ data: Data, id: KeyPath<Data.Element, ID>, alignment: VerticalAlignment = .top, spacing: CGFloat = 0, @ViewBuilder item: @escaping (Data.Element) -> Item) where Data: RandomAccessCollection, ID: Hashable, Item: View, Content == ForEach<Data, ID, Item> {
        self.init(alignment: alignment, spacing: spacing) {
            ForEach(data, id: id) { element in
                item(element)
            }
        }
    }
    
    public init<Data, Item>(_ data: Data, alignment: VerticalAlignment = .top, spacing: CGFloat = 0, @ViewBuilder item: @escaping (Data.Element) -> Item) where Data: RandomAccessCollection, Data.Element: Identifiable, Item: View, Content == ForEach<Data, Data.Element.ID, Item> {
        self.init(alignment: alignment, spacing: spacing) {
            ForEach(data, id: \.id) { element in
                item(element)
            }
        }
    }
    
    public init<Data, ID, Item>(_ data: Binding<Data>, id: KeyPath<Binding<Data>.Element, ID>, alignment: VerticalAlignment = .top, spacing: CGFloat = 0, @ViewBuilder item: @escaping (Binding<Data.Element>) -> Item) where Data: RandomAccessCollection, ID: Hashable, Item: View, Content == ForEach<Binding<Data>, ID, Item> {
        self.init(alignment: alignment, spacing: spacing) {
            ForEach(data, id: id) { element in
                item(element)
            }
        }
    }
    
    public init<Data, Item>(_ data: Binding<Data>, alignment: VerticalAlignment = .top, spacing: CGFloat = 0, @ViewBuilder item: @escaping (Binding<Data.Element>) -> Item) where Data: RandomAccessCollection, Data.Element: Identifiable, Item: View, Content == ForEach<Binding<Data>, Data.Element.ID, Item> {
        self.init(alignment: alignment, spacing: spacing) {
            ForEach(data, id: \.id) { element in
                item(element)
            }
        }
    }

    public var body: some View {
        if #available(iOS 17, *) {
            ScrollView(.horizontal) {
                HStack(alignment: alignment, spacing: spacing) {
                    content()
                }
                .scrollTracking(coordinateSpace: .named(coordinateSpaceName))
            }
            .coordinateSpace(.named(coordinateSpaceName))
            .scrollIndicators(.hidden)
        } else {
            ScrollView(.horizontal) {
                HStack(alignment: alignment, spacing: spacing) {
                    content()
                }
                .scrollTracking(coordinateSpace: .named(coordinateSpaceName))
            }
            .coordinateSpace(name: coordinateSpaceName)
            .scrollIndicators(.hidden)
        }
    }
}
