//
//  Triangle.swift
//  ChaosThree
//
//  Created by Fu Lam Diep on 14.04.21.
//

import Foundation
import ChaosMath

public struct Triangle {
    public private(set) var points: [Point3]

    public var normal: Vec3 {
        let x = points[1] - points[0]
        let y = points[2] - points[0]
        return x.cross(y)
    }

    public var components: [Float] {
        points.reduce([], { $0 + $1.components })
    }

    public init (_ a: Point3, _ b: Point3, _ c: Point3) {
        self.points = [a, b, c]
    }
}
