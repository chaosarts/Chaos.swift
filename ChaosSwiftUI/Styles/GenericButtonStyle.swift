//
//  Created by Fu Lam Diep on 31.08.24.
//

import SwiftUI

public struct GenericButtonStyle<Content>: ButtonStyle where Content: View {

    @Environment(\.isEnabled) var isEnabled

    @Environment(\.isBusy) var isBusy

    private var isDisabled: Bool {
        !isEnabled || isBusy
    }

    private let content: (Configuration, _ isEnabled: Bool, _ isBusy: Bool) -> Content

    public init(@ViewBuilder _ content: @escaping (Configuration, _ isEnabled: Bool, _ isBusy: Bool) -> Content) {
        self.content = content
    }

    public func makeBody(configuration: Configuration) -> some View {
        content(configuration, isEnabled, isBusy)
    }
}

extension ButtonStyle where Self == GenericButtonStyle<AnyView> {
    static var example: some ButtonStyle {
        GenericButtonStyle{ configuration, isEnabled, isBusy in
            configuration.label
                .opacity(isBusy ? 0 : 1)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .frame(minWidth: 44, minHeight: 44)
                .background(.black)
                .foregroundStyle(.white)
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
}

#Preview {
    Button("Press me") {

    }
    .buttonStyle(.example)
}
