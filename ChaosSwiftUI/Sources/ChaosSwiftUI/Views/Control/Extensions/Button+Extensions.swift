//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 25.08.24.
//

import SwiftUI

extension Button {
    public init(_ title: String, icon: Image, action: @escaping () -> Void) where Label == SwiftUI.Label<Text, Image>{
        self.init(action: action) {
            Label {
                Text(title)
            } icon: {
                icon
            }
        }
    }
}
