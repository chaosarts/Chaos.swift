//
//  Copyright © 2024 Fu Lam Diep <fulam.diep@gmail.com>
//

import SwiftUI

struct RippleEffectModifier: ViewModifier {

    static let coordinateSpaceName: String = "ChaosSwiftUI.RippleEffectModifier"

    @State private var data: Data = Data(position: .zero,
                                         opacity: .zero,
                                         scale: .zero)

    private let rippleColor: Color

    var tapGesture: some Gesture {
        SpatialTapGesture(coordinateSpace: .named(Self.coordinateSpaceName))
            .onEnded { value in
                data.scale = 0
                data.opacity = 1
                data.position = value.location
                withAnimation(.easeInOut(duration: 0.5)) {
                    data.scale = 3
                    data.opacity = 0
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
#if DEBUG
    static var rippleExample: some ButtonStyle {
        GenericButtonStyle { configuration, isEnabled, isBusy in
            configuration.label
                .opacity(isBusy ? 0 : 1)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .frame(minWidth: 44, minHeight: 44)
                .background(.black)
                .foregroundStyle(.white)
                .rippleEffect(.white.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .opacity(configuration.isPressed ? 0.5 : 1)
                .opacity(!isEnabled || isBusy ? 0.5 : 1)
                .overlay {
                    if isBusy {
                        ProgressView().progressViewStyle(.circular)
                    }
                }
        }
    }
#endif
}

#Preview {
    Button("Press me") {
        
    }
    .buttonStyle(.rippleExample)
}
