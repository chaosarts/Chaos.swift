//
//  Shape.swift
//  ChaosThree
//
//  Created by Fu Lam Diep on 14.04.21.
//

import Foundation
import ChaosMath
import ChaosCore

public class Mesh: NSObject {

    // MARK: Nested Types

    public typealias PrimitiveType = MTLPrimitiveType


    // MARK: Meta properties

    private var log: Log = Log(Mesh.self)


    // MARK: Data properties

    public weak var dataSource: MeshDataSource?

    public weak var delegate: MeshDelegate?

    private var vertices: [Vec3] = []

    private var indices: [Int] = []

    public var vertexSequence: [Vec3] { indices.map({ vertices[$0] }) }

    public var components: [Vec3.Component] { vertexSequence.reduce([], { $0 + $1.components }) }


    // MARK: Appearance Properties

    public private(set) var bounds: Box3 = .null


    // MARK: Update Properties

    public var needsUpdate: Bool = true


    // MARK: Control Data

    public func reloadVertices (withPrimitiveType primitiveType: PrimitiveType) {
        vertices = []
        indices = []
        bounds = .null

        guard let dataSource = dataSource else { return }
        delegate?.mesh(self, willReloadVerticesWithPrimitiveType: primitiveType)

        let numberOfVertices = dataSource.mesh(self, numberOfVerticesForPrimitiveType: primitiveType)
        guard (numberOfVertices % primitiveType.vertexCount) == 0 else {
            fatalError("Inconsistent vertex count. Number of vertices (\(numberOfVertices)) must be devidable by the " +
                        "number of vertices per primitve (\(primitiveType.rawValue))")
        }

        for index in 0..<numberOfVertices {
            let vertex = dataSource.mesh(self, vertexAt: index)
            appendVertex(vertex)
        }

        bounds = self.bounds(for: vertices, withMinBox: nil)
        delegate?.mesh(self, didReloadVerticesWithPrimitiveType: primitiveType)
    }

    public func reloadVertices (at indices: [Int], withPrimitiveType primitiveType: PrimitiveType) {
        guard let dataSource = dataSource else { return }
        delegate?.mesh(self, didReloadVerticesAt: indices, withPrimitiveType: primitiveType)

        var newVertices: [Vec3] = []
        for index in indices {
            guard index >= 0 && index < indices.count else {
                fatalError("Invalid index (\(index)) for mesh of \(vertices.count) vertices.")
            }

            let vertex = dataSource.mesh(self, vertexAt: index)
            newVertices.append(vertex)
            vertices[self.indices[index]] = vertex
        }

        bounds = self.bounds(for: newVertices, withMinBox: bounds)
        delegate?.mesh(self, didReloadVerticesAt: indices, withPrimitiveType: primitiveType)
    }

    /// Calculates the bounding box for the given set of vertices. If `minBox` is specified the resulting bounding box
    /// will have at least this extend. If the list of vertices is empty and no `minBox` is specified a null box is
    /// returned.
    /// - Parameter vertices: The list of vertices to calculate the bounding box for.
    /// - Parameter minBox: Specifies the minimum extend of the resulting box.
    private func bounds (for vertices: [Vec3], withMinBox minBox: Box3? = nil) -> Box3 {
        guard vertices.count > 0 else {
            return minBox ?? .null
        }

        var min: Point3 = .infinity
        var max: Point3 = -.infinity

        if let box = minBox, !box.isNull {
            min = box.origin
            max = Point3(box.maxX, box.maxY, box.maxZ)
        }

        for vertex in vertices {
            min.x = Swift.min(min.x, vertex.x)
            min.y = Swift.min(min.y, vertex.y)
            min.z = Swift.min(min.z, vertex.z)

            max.x = Swift.max(max.x, vertex.x)
            max.y = Swift.max(max.y, vertex.y)
            max.z = Swift.max(max.z, vertex.z)
        }

        return Box3(minX: min.x, minY: min.y, minZ: min.z, maxX: max.x, maxY: max.y, maxZ: max.z)
    }

    private func appendVertex (_ vertex: Vec3) {
        if let index = vertices.index(of: vertex) {
            indices.append(index)
        } else {
            indices.append(vertices.count)
            vertices.append(vertex)
        }
    }

    private func insertVertex (_ vertex: Vec3, at index: Int) {
        var insertionIndex = max(0, min(vertices.count, index))
        if let vertexIndex = vertices.index(of: vertex) {
            indices.insert(vertexIndex, at: insertionIndex)
        } else {
            indices.insert(vertices.count, at: insertionIndex)
            vertices.append(vertex)
        }
    }

    public func setNeedsUpdate () {
        needsUpdate = true
    }
}
