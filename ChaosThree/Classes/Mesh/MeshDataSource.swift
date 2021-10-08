//
//  ShapeDataSource.swift
//  ChaosThree
//
//  Created by Fu Lam Diep on 06.07.21.
//

import Foundation
import ChaosMath

public protocol MeshDataSource: AnyObject {

    /// Asks the data source for the number of vertices to take. The value should be devidable by the number of vertices
    /// per primitive. Therefore the method should check what primitive type the given mesh desires.
    /// - Parameter mesh: The mesh asking for the number of vertices.
    /// - Returns: The number of vertices the mesh should take.
    func mesh (_ mesh: Mesh, numberOfVerticesForPrimitiveType primitiveType: Mesh.PrimitiveType) -> Int

    /// Asks the data source for the vertex at given index.
    /// - Parameter mesh: The mesh asking for the vertex
    /// - Parameter index: The index of the vertex to return.
    /// - Returns: The vertex as `Vec3` corresponding to `index`
    func mesh (_ mesh: Mesh, vertexAt index: Int) -> Vec3
}
