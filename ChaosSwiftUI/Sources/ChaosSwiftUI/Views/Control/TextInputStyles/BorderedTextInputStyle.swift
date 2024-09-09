//
//  TextInput.swift
//
//  Created by Fu Lam Diep on 25.07.24.
//

import SwiftUI

public struct BorderedTextInputStyle: TextFieldStyle {
    public func _body(configuration: TextField<Self._Label>) -> some View {
        return configuration
            .padding(.vertical, 8)
            .padding(.horizontal, 10)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray)
                    .foregroundColor(.clear)
            }
    }
}


extension TextFieldStyle where Self == BorderedTextInputStyle {
    static var bordered: Self { BorderedTextInputStyle() }
}

#Preview {
    Form {
        TextField("Hello", text: .constant(""))
            .textFieldStyle(.bordered)
    }
    .formStyle(.columns)
}
