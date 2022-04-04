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
        let r = CGFloat((hex & 0xff0000) >> 16) / 255
        let g = CGFloat((hex & 0x00ff00) >> 8) / 255
        let b = CGFloat((hex & 0x0000ff)) / 255

        self.init(red: r, green: g, blue: b, alpha: alpha)
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
