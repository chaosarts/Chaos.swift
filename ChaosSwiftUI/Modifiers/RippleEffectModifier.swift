//
//  Copyright © 2024 Fu Lam Diep <fulam.diep@gmail.com>
//

import SwiftUI

struct RippleEffectModifier: ViewModifier {

    static let coordinateSpaceName: String = "ChaosSwiftUI.RippleEffectModifier"

    @State private var data = Data(position: .zero, opacity: 1, scale: 0)

    private let rippleColor: Color

    var tapGesture: some Gesture {

        SpatialTapGesture(coordinateSpace: .named(Self.coordinateSpaceName))
            .onEnded { value in
                withAnimation(.easeIn(duration: 0)) {
                    data = Data(position: value.location, opacity: 1, scale: 0)
                }
                withAnimation(.easeInOut(duration: 1.5)) {
                    data.scale = 3
                    data.opacity = 0
                }
                withAnimation(.easeIn.delay(1.5)) {
                    data = Data(position: .zero, opacity: 1, scale: 0)
                }
            }
    }

    init(rippleColor: Color) {
        self.rippleColor = rippleColor
    }

    func body(content: Content) -> some View {
        content
            .overlay {
                Circle()
                    .scale(data.scale, anchor: .center)
                    .scaledToFill()
                    .position(data.position)
                    .opacity(data.opacity)
                    .foregroundStyle(rippleColor)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
            }
            .simultaneousGesture(tapGesture)
            .coordinateSpace(name: Self.coordinateSpaceName)
    }

    private struct Data {
        var position: CGPoint
        var opacity: CGFloat
        var scale: CGFloat
    }
}

extension View {
    public func rippleEffect(_ rippleColor: Color = .ripple) -> some View {
        modifier(RippleEffectModifier(rippleColor: rippleColor))
    }
}

extension ButtonStyle where Self == GenericButtonStyle<AnyView> {
    static var rippleExample: some ButtonStyle {
        GenericButtonStyle { configuration, isEnabled, isBusy in
            configuration.label
                .opacity(isBusy ? 0 : 1)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .frame(minWidth: 44, minHeight: 44)
                .background(.black)
                .foregroundStyle(.white)
                .rippleEffect(.white.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .opacity(!isEnabled || isBusy ? 0.5 : 1)
                .overlay {
                    if isBusy {
                        ProgressView().progressViewStyle(.circular)
                    }
                }
        }
    }
}

#Preview {
    Button("Press me") {
        
    }
    .buttonStyle(.rippleExample)
}
