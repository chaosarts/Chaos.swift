//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 04.04.22.
//

import Foundation
import UIKit

public extension UIColor {

    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        if hex > 0xFFF {
            let r = CGFloat((hex & 0xff0000) >> 16) / 255
            let g = CGFloat((hex & 0x00ff00) >> 8) / 255
            let b = CGFloat((hex & 0x0000ff)) / 255
            self.init(red: r, green: g, blue: b, alpha: alpha)
        } else {
            let red = CGFloat(((hex & 0xF00) >> 4) + ((hex & 0xF00) >> 8))
            let green = CGFloat((hex & 0x0F0) + ((hex & 0x0F0) >> 4))
            let blue = CGFloat((hex & 0x00F) + ((hex & 0x0F) << 4))
            self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
        }
    }

    convenience init(light: UIColor, dark: UIColor) {
        self.init { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .light:
                return light
            case .dark:
                return dark
            case .unspecified:
                return light
            @unknown default:
                return light
            }
        }
    }
}


//extension UIColor: ExpressibleByIntegerLiteral {
//    public convenience init(integerLiteral value: Int) {
//        self.init(hex: value)
//    }
//}
