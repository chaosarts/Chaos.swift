//
//  Created by Fu Lam Diep on 06.09.24.
//
import SwiftUI

/// A ``ScrollView`` wrapper to manage fixed hero view with spring effect at the top of the view.
///
///
public struct HeroScrollView<HeroView, Content>: View where HeroView: View, Content: View {

    /// Tracks the frame of the scroll view content, in order to resize the hero view.
    @State private var scrollFrame: CGRect = .zero

    /// Provides the ideal height of the hero view.
    ///
    /// When `minY` of the scroll view content is 0, the hero view have this height.
    private let idealHeight: CGFloat

    /// A view builder to build the hero view.
    private let heroView: () -> HeroView

    /// A view builder to build the actual content of the scroll view
    private let content: () -> Content

    /// Provides a coordinate space name to enable zero based scroll tracking.
    private let coordinateSpaceName = "HeroScrollView.CoordinateSpace"

    public init(idealHeight: CGFloat = 376,
                @ViewBuilder heroView: @escaping () -> HeroView,
                @ViewBuilder content: @escaping () -> Content) {
        self.idealHeight = idealHeight
        self.heroView = heroView
        self.content = content
    }

    public var body: some View {
        ScrollView {
            VStack {
                /*
                 The order of the modifiers applied to the hero view is crucial.

                 We want the hero view to shrink and grow proportional to the minY of the scroll view content relative
                 to its ideal height (first modifier). Its the developers responsibility to provide a minimum height of
                 the hero view in order to prevent the view from shrinking to zero. A minimum height in turn can cause
                 the hero view to overflow the first modifier, which is why we append clipping.

                 The hero view is an element of the VStack and is constantly growing or shrinking, which causes the
                 VStack to constantly re-position its elements during scrolling. This is where the fourth frame comes
                 in play, which creates a new frame container with a constant ideal height.

                 Last but not least, we want the frame to stay at the top. Hence we compensate the minY of scroll view
                 content frame with an negative offset, which doesn't affect the views position relative to the VStack.

                 NOTICE: A paged tab view such as an image carousel is required to have a minimum height. Otherwise,
                 the page selection jumps back to the first element, when the first modifier causes a height of zero.
                 */
                heroView()
                    .frame(height: max(0, idealHeight + scrollFrame.minY), alignment: .top)
                    .clipped()
                    .frame(height: idealHeight, alignment: .top)
                    .offset(y: -scrollFrame.minY)

                content()
            }
            .background {
                GeometryReader { proxy in
                    Color.clear.onChange(of: proxy.frame(in: .named(coordinateSpaceName))) { value in
                        scrollFrame = value
                    }
                }
            }
        }
        .coordinateSpace(name: coordinateSpaceName)
    }
}

#Preview {
    struct ExampleView: View {

        @State var selection = 0

        @State var isFavorite = false

        let imageURLs: [URL?] = [
            URL(string: "https://picsum.photos/id/203/800/800"),
            URL(string: "https://picsum.photos/id/201/800/400"),
            URL(string: "https://picsum.photos/id/301/800/400"),
        ]

        var body: some View {
            NavigationView {
                HeroScrollView(idealHeight: 376) {
                    TabView(selection: $selection) {
                        ForEach(imageURLs.indices, id: \.self) { index in
                            let url = imageURLs[index]
                            AsyncImage(url: url) { content in
                                content.image.aspectRatio(1, contentMode: .fill)
                            }
                            .overlay { Color.black.opacity(0.03) }
                            .tag(index)
                        }
                    }
                    .tabViewStyle(.page)
                } content: {
                    VStack(spacing: 24) {
                        ForEach(0..<3, id: \.self) { _ in
                            Text("Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.")
                        }

                        Button("Buy...") {

                        }
                    }
                    .padding()
                }
                .navigationTitle("Hello")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    Toggle(isOn: $isFavorite) {
                        Label("Add to notepad", systemImage: "heart")
                    }
                }
            }
        }
    }

    return ExampleView()
}
