//
//  Size3.swift
//  ChaosMath
//
//  Created by Fu Lam Diep on 12.07.21.
//

import Foundation

public struct t_size3<Component: SignedNumeric> {

    public var width: Component

    public var height: Component

    public var depth: Component

    public var volume: Component { width * height * depth }

    public mutating func insetBy (width: Component = 0, height: Component = 0, depth: Component = 0) {
        self.width -= width
        self.height -= height
        self.depth -= depth
    }
}


public typealias Size3i = t_size3<Int>
public typealias Size3f = t_size3<Float>
public typealias Size3d = t_size3<Double>
public typealias Size3 = Size3f

