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
public struct Carousel<Content>: CarouselView where Content: View {

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

    /**
     Provides an identifier to define a coordinate space to enabled scroll tracking of the content relative to the
     surrounding scroll view.
     */
    private let coordinateSpaceName: String = "ChaosSwiftUI.Carousel"

    /**
     Initializes the carousel, where elements may be arbitrary.
     */
    public init(alignment: VerticalAlignment, spacing: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content
    }

    public var body: some View {
        ScrollView(.horizontal) {
            HStack(alignment: alignment, spacing: spacing) {
                content()
            }
            .scrollTracking(coordinateSpace: .named(coordinateSpaceName))
        }
        .apply { content in
            if #available(iOS 17, *) {
                content.coordinateSpace(.named(coordinateSpaceName))
            } else {
                content.coordinateSpace(name: coordinateSpaceName)
            }
        }
        .scrollIndicators(.hidden)
    }
}
