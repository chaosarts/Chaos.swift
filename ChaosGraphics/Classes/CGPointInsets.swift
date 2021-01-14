//
//  CGPointInsets.swift
//  Chaos
//
//  Created by Fu Lam Diep on 13.11.20.
//

import CoreGraphics

public struct CGPointInsets {
    public var leading: CGFloat
    public var trailing: CGFloat
}

public extension CGPointInsets {
    static var zero: CGPointInsets { CGPointInsets(leading: 0, trailing: 0) }
}
