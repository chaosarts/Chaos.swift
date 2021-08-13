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

    var sphereDataSource: SphereShapeDataSource = SphereShapeDataSource()

    public func testShapeDataSource () {
        let shape = Shape()
        shape.dataSource = self
        shape.reloadData(for: .point)
        XCTAssertEqual(3, shape.vertices.count)
        XCTAssertEqual(10, shape.vertexSequence.count)
        XCTAssertEqual(30, shape.components.count)
    }

    public func testSphereDataSource () {
        let shape = Shape()
        sphereDataSource.latitudeCount = 10
        shape.dataSource = sphereDataSource
        shape.reloadData(for: .point)

    }
}


extension ShapeTest: ShapeDataSource {

    public var center: Vec3 { .zero }

    public func numberOfPrimitives(_ shape: Shape, forType primitiveType: Shape.Primitive) -> Int {
        10
    }

    public func shape(_ shape: Shape, verticesForPrimitiveAt index: Int, ofType primitiveType: Shape.Primitive) -> [Vec3] {
        let vertices = [.zero, Vec3(1, 1, 1), Vec3(0, 0, 1)]
        var output: [Vec3] = []

        while output.count < primitiveType.rawValue {
            output.append(vertices[(index + output.count) % vertices.count])
        }
        return output
    }
}
