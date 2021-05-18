//
//  Shape.swift
//  ChaosThree
//
//  Created by Fu Lam Diep on 14.04.21.
//

import Foundation
import ChaosMath

public protocol ShapeDataSource: class {

    func numberOfVertices (_ shape: Shape) -> Int

    func shape (_ shape: Shape, vertexAt index: Int) -> Vec3
}

public class Shape {

    public weak var dataSource: ShapeDataSource?

    public private(set) var vertices: [Vec3] = []

    public func reloadData () {
        vertices = []
        guard let dataSource = dataSource else { return }

        for index in 0..<dataSource.numberOfVertices(self) {
            vertices.append(dataSource.shape(self, vertexAt: index))
        }
    }
}
