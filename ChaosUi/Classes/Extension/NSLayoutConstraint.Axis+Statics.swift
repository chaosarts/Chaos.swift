//
//  NSLayoutConstraint.Axis+Statics.swift
//  Chaos
//
//  Created by Fu Lam Diep on 03.11.20.
//

import Foundation

public extension NSLayoutConstraint.Axis {
    var perpendicular: NSLayoutConstraint.Axis {
        switch self {
        case .horizontal:
            return .vertical
        case .vertical:
            return .horizontal
        }
    }
}
