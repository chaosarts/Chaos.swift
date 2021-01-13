//
//  CGPointInsets.swift
//  Chaos
//
//  Created by Fu Lam Diep on 13.11.20.
//

import Foundation

public struct CGPointInsets {
    public leading: CGFloat
    public trailing: CGFloat
}

public extension CGPointInsets {
    static var zero: CGPointInsets { CGPointInsetsZero }
}
