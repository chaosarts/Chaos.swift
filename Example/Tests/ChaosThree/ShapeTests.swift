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
