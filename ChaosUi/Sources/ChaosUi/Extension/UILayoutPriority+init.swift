#if canImport(UIKit)
//
//  UILayoutPriority+init.swift
//  ChaosUi
//
//  Created by Fu Lam Diep on 17.10.20.
//

import UIKit

extension UILayoutPriority: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self.init(Float(value))
    }
}

extension UILayoutPriority: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Float) {
        self.init(value)
    }
}

#endif