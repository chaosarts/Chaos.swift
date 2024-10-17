#if canImport(UIKit)
//
//  UIClockProgress.swift
//  ChaosAnimation
//
//  Created by Fu Lam Diep on 26.03.21.
//

import UIKit
import ChaosGraphics
import ChaosAnimation

@IBDesignable
open class UIClockProgress: UIView {

    @IBInspectable open dynamic var startAngle: CGFloat = .circleTopAngle

    @IBInspectable open dynamic var endAngle: CGFloat = .circleTopAngle + 2 * .pi

    public var angle: CGFloat { endAngle - startAngle }

    public var radius: CGFloat = 1.0 {
        didSet { invalidateIntrinsicContentSize() }
    }

    open override var intrinsicContentSize: CGSize {
        let diameter = 2 * radius
        return CGSize(width: diameter, height: diameter)
    }
}

#endif