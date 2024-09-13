//
//  TextInput.swift
//
//  Created by Fu Lam Diep on 25.07.24.
//

import SwiftUI

public struct GenericTextFieldStyle<Content>: TextFieldStyle where Content: View {

    private let content: (TextField<Self._Label>) -> Content

    init(@ViewBuilder content: @escaping (TextField<Self._Label>) -> Content) {
        self.content = content
    }

    public func _body(configuration: TextField<Self._Label>) -> some View {
        content(configuration)
    }
}

extension TextFieldStyle where Self == GenericTextFieldStyle<EmptyView> {
    static var example: some TextFieldStyle {
        GenericTextFieldStyle { configuration in
            configuration
                .padding(.vertical, 8)
                .padding(.horizontal, 10)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray)
                        .foregroundColor(.clear)
                }
        }
    }
}

#Preview {
    Form {
        TextField("Hello", text: .constant(""))
            .textFieldStyle(.example)
    }
    .formStyle(.columns)
}
