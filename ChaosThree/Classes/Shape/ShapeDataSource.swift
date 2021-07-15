//
//  ShapeDataSource.swift
//  ChaosThree
//
//  Created by Fu Lam Diep on 06.07.21.
//

import Foundation
import ChaosMath

public protocol ShapeDataSource: class {

    var center: Vec3 { get }

    func numberOfPrimitives (_ shape: Shape, forType primitiveType: Shape.Primitive) -> Int
    func shape (_ shape: Shape, verticesForPrimitiveAt index: Int, ofType primitiveType: Shape.Primitive) -> [Vec3]
}
