//
//  GridMeshDataSource.swift
//  ChaosThree
//
//  Created by Fu Lam Diep on 13.08.21.
//

import Foundation
import ChaosMath

public class GridMeshDataSource: MeshDataSource {

    public var verticalCount: Int = 10

    public var horizontalCount: Int = 10

    public var verticalSpacing: Float = 1

    public var horizontalSpacing: Float = 1

    public func mesh(_ mesh: Mesh, verticesForPrimitve primitive: Mesh.PrimitiveType) -> [Vec3] {
        []
    }


}
