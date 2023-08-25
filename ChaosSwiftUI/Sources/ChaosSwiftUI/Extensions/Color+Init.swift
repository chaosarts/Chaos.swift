//
//  Color+Init.swift
//  Chrono24
//
//  Created by Fu Lam Diep on 30.04.22.
//

import Foundation
import SwiftUI

public extension Color {
    init(_ colorSpace: RGBColorSpace = .sRGB, hex: Int) {
        let red = CGFloat((hex & 0xFF0000) >> 16)
        let green = CGFloat((hex & 0x00FF00) >> 8)
        let blue = CGFloat((hex & 0x0000FF))

        self.init(colorSpace, red: red / 255, green: green / 255, blue: blue / 255)
    }
}
