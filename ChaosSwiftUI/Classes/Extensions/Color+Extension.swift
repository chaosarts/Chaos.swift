//
//  Color+Extension.swift
//  ChaosSwiftUI
//
//  Created by Fu Lam Diep on 13.10.21.
//

import SwiftUI

public extension Color {
    public static func random (colorSpace: RGBColorSpace = .sRGB, opacity: Double = 1) -> Color {
        Color(colorSpace, red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), opacity: opacity)
    }
}
