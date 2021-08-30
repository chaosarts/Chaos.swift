//
//  ShapeTests.swift
//  Chaos_Tests
//
//  Created by Fu Lam Diep on 09.08.21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import XCTest
import ChaosMath
@testable import ChaosThree

public class ShapeTest: XCTestCase {

    var sphereDataSource: SphereMeshDataSource = SphereMeshDataSource()

    public func testShapeDataSource () {
        let shape = Mesh()
        shape.dataSource = self
        shape.reloadData(for: .point)
        XCTAssertEqual(3, shape.vertices.count)
        XCTAssertEqual(10, shape.vertexSequence.count)
        XCTAssertEqual(30, shape.components.count)
    }

    public func testSphereDataSource () {
        let shape = Mesh()
        sphereDataSource.latitudeCount = 10
        shape.dataSource = sphereDataSource
        shape.reloadData(for: .point)

    }
}


extension ShapeTest: MeshDataSource {

    public var center: Vec3 { .zero }

    public func numberOfPrimitives(_ shape: Mesh, forType primitiveType: Mesh.Primitive) -> Int {
        10
    }

    public func shape(_ shape: Mesh, verticesForPrimitiveAt index: Int, ofType primitiveType: Mesh.Primitive) -> [Vec3] {
        let vertices = [.zero, Vec3(1, 1, 1), Vec3(0, 0, 1)]
        var output: [Vec3] = []

        while output.count < primitiveType.rawValue {
            output.append(vertices[(index + output.count) % vertices.count])
        }
        return output
    }
}
