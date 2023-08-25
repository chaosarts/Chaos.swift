//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 14.04.22.
//

import SwiftUI

public struct ImageButton: View {

    private let image: Image

    private let action: () -> Void

    public init(image: Image, action: @escaping @autoclosure () -> Void) {
        self.image = image
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            self.image
        }
    }
}

