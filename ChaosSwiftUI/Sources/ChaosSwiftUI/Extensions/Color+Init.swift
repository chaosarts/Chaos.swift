//
//  Color+Init.swift
//  Chrono24
//
//  Created by Fu Lam Diep on 30.04.22.
//

#if canImport(UIKit)
import UIKit
#endif
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

    #if canImport(UIKit)
    init(light: UIColor, dark: UIColor, unspecified: UIColor? = nil) {
        self.init(uiColor: UIColor(dynamicProvider: { trait in
            switch trait.userInterfaceStyle {
            case .light:
                light
            case .dark:
                dark
            case .unspecified:
                unspecified ?? light
            }
        }))
    }

    init(light: Int, dark: Int, unspecified: Int? = nil) {
        var unspecifiedColor: UIColor?
        if let unspecified {
            unspecifiedColor = Self.uiColor(forHex: unspecified)
        }
        self.init(light: Self.uiColor(forHex: light),
                  dark: Self.uiColor(forHex: dark),
                  unspecified: unspecifiedColor)
    }

    static func uiColor(forComponents components: (red: CGFloat, green: CGFloat, blue: CGFloat), alpha: CGFloat = 1) -> UIColor {
        UIColor(red: components.red,
                green: components.green,
                blue: components.blue,
                alpha: alpha)
    }

    static func uiColor(forHex hex: Int, alpha: CGFloat = 1) -> UIColor {
        uiColor(forComponents: colorComponents(for: hex), alpha: alpha)
    }
    #endif

    static func colorComponents(for hex: Int) -> (red: CGFloat, green: CGFloat, blue: CGFloat) {
        if hex > 0xFFF {
            let red = CGFloat((hex & 0xFF0000) >> 16)
            let green = CGFloat((hex & 0x00FF00) >> 8)
            let blue = CGFloat((hex & 0x0000FF))
            return (red: red / 255, green: green / 255, blue: blue / 255)
        } else {
            let red = CGFloat(((hex & 0xF00) >> 4) + ((hex & 0xF00) >> 8))
            let green = CGFloat((hex & 0x0F0) + ((hex & 0x0F0) >> 4))
            let blue = CGFloat((hex & 0x00F) + ((hex & 0x0F) << 4))
            return (red: red / 255, green: green / 255, blue: blue / 255)
        }
    }
}
