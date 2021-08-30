//
//  ShapeDataSource.swift
//  ChaosThree
//
//  Created by Fu Lam Diep on 06.07.21.
//

import Foundation
import ChaosMath

public protocol MeshDataSource: AnyObject {

    func mesh (_ mesh: Mesh, verticesFor primitiveType: Mesh.PrimitiveType) -> [Vec3]
}
