//
//  Color+Init.swift
//  Chrono24
//
//  Created by Fu Lam Diep on 30.04.22.
//

import ChaosUi
import SwiftUI

public extension Color {
    init(_ colorSpace: RGBColorSpace = .sRGB, hex: Int) {
        if hex > 0xFFF {
            let red = CGFloat((hex & 0xFF0000) >> 16)
            let green = CGFloat((hex & 0x00FF00) >> 8)
            let blue = CGFloat((hex & 0x0000FF))
            self.init(colorSpace, red: red / 255, green: green / 255, blue: blue / 255)
        } else {
            let red = CGFloat(((hex & 0xF00) >> 4) + ((hex & 0xF00) >> 8))
            let green = CGFloat((hex & 0x0F0) + ((hex & 0x0F0) >> 4))
            let blue = CGFloat((hex & 0x00F) + ((hex & 0x0F) << 4))
            self.init(colorSpace, red: red / 255, green: green / 255, blue: blue / 255)
        }
    }

    init(light: UIColor, dark: UIColor) {
        self.init(uiColor: UIColor(light: light, dark: dark))
    }
}
