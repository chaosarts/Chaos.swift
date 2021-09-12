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

    // MARK: Optional functions

    /// Tells the data source to prepare the vertices to provide, if neccessary. Preparing vertices can be useful, when
    /// the data source is generating vertices just-in-time. One can generate an internal array of vertices. This method
    /// will be called before `numberOfVertices`.
    /// - Parameter mesh: The mesh telling the data source to prepare.
    func mesh (_ mesh: Mesh, prepareForPrimitiveType primitiveType: Mesh.PrimitiveType)
}


// MARK: - Default Implementation

public extension MeshDataSource {
    func mesh (_ mesh: Mesh, prepareForPrimitiveType primitiveType: Mesh.PrimitiveType) {}
}
