//
//  Shape.swift
//  ChaosThree
//
//  Created by Fu Lam Diep on 14.04.21.
//

import Foundation
import ChaosMath

public class Shape {

    public weak var dataSource: ShapeDataSource?

    public private(set) var vertices: [Vec3] = []

    public private(set) var indices: [Int] = []

    public var vertexSequence: [Vec3] { indices.map({ vertices[$0] }) }

    public var components: [Vec3.Component] { vertexSequence.reduce([], { $0 + $1.components }) }

    public func reloadData (for primitiveType: Primitive) {
        vertices = []
        indices = []
        guard let dataSource = dataSource else { return }

        var tmpVertices: [Vec3] = []
        for index in 0..<dataSource.numberOfPrimitives(self, forType: primitiveType) {
            let vertices = dataSource.shape(self, verticesForPrimitiveAt: index, ofType: primitiveType)
            if vertices.count != primitiveType.rawValue {
                fatalError("Invalid count of vertices (\(vertices.count)) for primitive type. Expected \(primitiveType.rawValue) vertices.")
            }
            tmpVertices.append(contentsOf: vertices)
        }
        tmpVertices.forEach({ self.appendVertex($0) })
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

public extension Shape {

    @objc enum Primitive: Int {
        case point = 1
        case line = 2
        case triangle = 3
    }
}
