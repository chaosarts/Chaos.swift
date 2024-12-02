//
//  Copyright © 2024 Fu Lam Diep <fulam.diep@gmail.com>
//

import SwiftUI

public struct LazyCarousel<Content>: CarouselView where Content: View {

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

    public init(alignment: VerticalAlignment, spacing: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content
    }

    public var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(alignment: alignment, spacing: spacing) {
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
