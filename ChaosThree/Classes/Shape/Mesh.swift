//
//  Shape.swift
//  ChaosThree
//
//  Created by Fu Lam Diep on 14.04.21.
//

import Foundation
import ChaosMath
import ChaosCore

public class Mesh {

    private var log: Log = Log(Mesh.self, levels: [.warn, .error])

    public weak var dataSource: MeshDataSource?

    public private(set) var vertices: [Vec3] = []

    public private(set) var indices: [Int] = []

    public var vertexSequence: [Vec3] { indices.map({ vertices[$0] }) }

    public var components: [Vec3.Component] { vertexSequence.reduce([], { $0 + $1.components }) }

    public func reloadData (for primitive: PrimitiveType) {
        vertices = []
        indices = []

        guard let dataSource = dataSource else { return }

        let vertices = dataSource.mesh(self, verticesFor: primitive)
        guard vertices.count % primitive.rawValue == 0 else {
            log.warn(format: "Vertex count inconcistency. Number of vertices (\(vertices.count)) must be devidable by the number of " + "vertices per primitive \(primitive.rawValue).")
            return
        }

        vertices.forEach({ self.appendVertex($0) })
    }

    private func appendVertex (_ vertex: Vec3) {
        if let index = vertices.index(of: vertex) {
            indices.append(index)
        } else {
            indices.append(vertices.count)
            vertices.append(vertex)
        }
    }
}

public extension Mesh {

    @objc enum PrimitiveType: Int {
        case point = 1
        case line = 2
        case triangle = 3
    }
}
