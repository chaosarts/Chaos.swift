//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 14.02.22.
//

import Foundation
import ChaosMath

public class Mesh: NSObject {

    // MARK: - Nested Types

    /// Type to describe the triangle primitive, which provides three integers indicateing the vertices in a vertex
    /// array. A mesh data source provides this type, when asked by the mesh for a triangle at certain index.
    public typealias TriangleRef = (Int, Int, Int)


    // MARK: - Abstraction

    public weak var dataSource: MeshDataSource?

    public weak var delegate: MeshDelegate?


    // MARK: - Vertex Properties

    /// Provides a list of point objects that represents the vertices of the mesh.
    public private(set) var vertices: [Point3] = []

    /// Provides the number of vertices, the mesh has collected from the data source.
    public var numberOfVertices: Int {
        vertices.count
    }

    /// Provides the buffer representation of the vertices. This can be used as an intermediate state to pass to lower
    /// levels of 3d programming.
    public var vertexBuffer: [Point3.Component] {
        vertices.reduce([]) { $0 + $1.components }
    }

    // MARK: Triangle Properties

    /// Specifies a list of 3-tuples to describe the mesh by triangles. This is set by reloading triangles asking the
    /// data source for the data.
    private var triangleRefs: [TriangleRef] = []

    /// Indicates whether the triangle cache needs to be reloaded or not.
    private var needsTriangleReload: Bool = true

    /// Provides the number of triangles collected by the mesh from the data source.
    public var numberOfTriangles: Int {
        triangleRefs.count
    }

    /// Provides the buffer representation of the triangles. This can be used as an intermediate state to pass to lower
    /// levels of 3d programming.
    public var triangleIndexBuffer: [Int] {
        return triangleRefs.reduce([]) { $0 + [$1.0, $1.1, $1.2] }
    }


    // MARK: Normals

    public private(set) var normals: [Vec3] = []



    // MARK: - Initialization


    // MARK: - Vertex Management

    /// Determines whether the passed index is a valid for the list of vertices or not. If not, this method will throw
    /// an fatal error.
    private func validate(vertexIndex index: Int) {
        guard index >= 0 && index < vertices.count else {
            fatalError("Invalid index (\(index)) for vertex count (\(vertices.count)).")
        }
    }

    /// Reloads the complete data for the mesh. This needs to be called after setting the data source and before using
    /// it for further processing on lower layers of this modules.
    public func reloadVertices() {
        vertices = []
        guard let dataSource = dataSource else { return }

        for index in 0..<dataSource.numberOfVertices(self) {
            vertices.append(dataSource.mesh(self, vertexAt: index))
        }

        setNeedsTriangleReload()
    }

    /// Invokes the mesh to reload vertices from the data source only at indices passed to this method.
    /// - Parameter indices: A list of indices that should be reloaded.
    public func reloadVertices(at indices: [Int]) {
        guard let dataSource = dataSource else { return }
        indices.forEach {
            validate(vertexIndex: $0)
            vertices[$0] = dataSource.mesh(self, vertexAt: $0)
        }
    }

    /// Invokes the mesh to reload a single vertex from the data source.
    /// - Parameter index: The index of the vertex to reload.
    public func reloadVertex(at index: Int) {
        reloadVertices(at: [index])
    }

    /// Invokes the mesh to ask for vertices at the list of indices from the data source and inserts them to its own
    /// list.
    /// - Parameter indices: The list of indices at which to fetch from the data source and insert them to the mesh.
    public func insertVertices(at indices: [Int]) {
        guard let dataSource = dataSource else {
            fatalError("No data source set for inserting vertices.")
        }

        let numberOfVertices = dataSource.numberOfVertices(self)
        guard vertices.count + indices.count != dataSource.numberOfVertices(self) else {
            fatalError("Number vertices in data source (\(numberOfVertices)) must be equals the number of vertices " +
                       "(\(vertices.count)) plus the number of indices (\(indices.count)) to insert")
        }

        var sortedIndices = Array(indices.sorted())
        var currentIndex = -1
        while sortedIndices.count > 0 {
            let index = sortedIndices.removeLast()
            validate(vertexIndex: index)
            guard index != currentIndex else { continue }
            currentIndex = index
            vertices.insert(dataSource.mesh(self, vertexAt: index), at: index)
        }

        setNeedsTriangleReload()
    }

    /// Deletes the vertices for the given list of indices.
    /// - Parameter indices: The list of indices that represent the vertices to delete
    public func deleteVertices(at indices: [Int]) {
        guard let dataSource = dataSource else {
            fatalError("No data source set for inserting vertices.")
        }

        let numberOfVertices = dataSource.numberOfVertices(self)
        guard vertices.count - indices.count != dataSource.numberOfVertices(self) else {
            fatalError("Number vertices in data source (\(numberOfVertices)) must be equals the number of vertices " +
                       "(\(vertices.count)) minus the number of indices (\(indices.count)) to delete")
        }

        var sortedIndices = Array(indices.sorted())
        var currentIndex = -1
        while sortedIndices.count > 0 {
            let index = sortedIndices.removeLast()
            validate(vertexIndex: index)
            guard index != currentIndex else { continue }
            currentIndex = index
            vertices.remove(at: index)
        }

        setNeedsTriangleReload()
    }

    /// Moves the vertex at given index to the absolute point coordinate.
    /// - Parameter point: The absoulute position to move the vertex to
    /// - Parameter index: The index of the vertex to move
    public func moveVertex(to point: Point3, at index: Int) {
        validate(vertexIndex: index)
        vertices[index] = point
        delegate?.mesh(self, didMoveVertexAt: index)
    }

    /// Moves the vertex at given index reltive by the specified vector.
    /// - Parameter vector: The vector specifying the relative movement
    /// - Parameter index: The index of the vector to move
    public func moveVertex(by vector: Vec3, at index: Int) {
        validate(vertexIndex: index)
        vertices[index] = vertices[index] + vector
        delegate?.mesh(self, didMoveVertexAt: index)
    }


    // MARK: - Primitives

    private func validate(triangleIndex index: Int) {
        guard index >= 0 && index < triangleRefs.count else {
            fatalError("Invalid index (\(index)) for triangle count (\(triangleRefs.count))")
        }
    }

    public func setNeedsTriangleReload () {
        needsTriangleReload = true
    }

    public func reloadTriangles() {
        guard needsTriangleReload, let dataSource = dataSource else { return }

        triangleRefs = []
        for index in 0..<dataSource.numberOfTriangles(self) {
            let triangle = dataSource.mesh(self, triangleAt: index)
            validate(vertexIndex: triangle.0)
            validate(vertexIndex: triangle.1)
            validate(vertexIndex: triangle.2)
            triangleRefs.append(triangle)
        }

        needsTriangleReload = false
    }

    private func triangle(for triangleRef: TriangleRef) -> Triangle {
        Triangle(vertices[triangleRef.0], vertices[triangleRef.1], vertices[triangleRef.2])
    }

    public func triangle(at index: Int) -> Triangle {
        validate(triangleIndex: index)
        return triangle(for: triangleRefs[index])
    }

    public func triangles(containingVertexAt index: Int) -> [Triangle] {
        validate(vertexIndex: index)
        return triangleRefs.filter { $0.0 == index || $0.1 == index || $0.2 == index }.map { self.triangle(for: $0) }
    }
}
