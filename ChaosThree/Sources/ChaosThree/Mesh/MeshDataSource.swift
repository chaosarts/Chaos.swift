//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 14.02.22.
//

import Foundation
import ChaosMath

public protocol MeshDataSource: AnyObject {

    /// Asks the data source for the number of vertices for the given mesh. This method will be called by the mesh in
    /// `reloadVertices`. The return value is the amount of calls of `mesh(:vertexAt:)` by the mesh.
    ///
    /// - Parameter mesh: The mesh asking for the number of vertices it should collect from the data source.
    /// - Returns: The number of vertices this data source provides.
    func numberOfVertices(_ mesh: Mesh) -> Int

    /// Asks the data source for the vertex at given index. This method will be called at several points of the mesh
    /// (`reloadVertices()`, `reloadVertices(at:)`, `insertVertices(at:)`.
    ///
    /// - Parameter mesh: The mesh asking for the vertex at given index
    /// - Parameter index: The index of the vertex to get.
    /// - Returns: The vertex for which the mesh asked for.
    func mesh(_ mesh: Mesh, vertexAt index: Int) -> Point3

    /// Asks the data source for the number of triangles it provides.
    /// - Parameter mesh: The mesh asking for the number of triangles.
    /// - Returns: The number of triangles to collect.
    func numberOfTriangles(_ mesh: Mesh) -> Int

    func mesh(_ mesh: Mesh, triangleAt index: Int) -> Mesh.TriangleRef

    func mesh(_ mesh: Mesh, normalForTriangleAt index: Int) -> Vec3

    func mesh(_ mesh: Mesh, normalForVertexAt index: Int) -> Vec3 
}


public extension MeshDataSource {
    func mesh(_ mesh: Mesh, normalForTriangleAt index: Int) -> Vec3 {
        let triangle = mesh.triangle(at: index)
        return triangle.normal.unified
    }

    func mesh(_ mesh: Mesh, normalForVertexAt index: Int) -> Vec3 {
        let triangles = mesh.triangles(containingVertexAt: index)
        return triangles.reduce(Vec3()) { $0 + $1.normal }.unified
    }
}
