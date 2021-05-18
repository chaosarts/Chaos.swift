//
//  Vec3Tests.swift
//  Chaos_Example
//
//  Created by Fu Lam Diep on 12.04.21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
@testable import ChaosMath

public class Vec3Tests: XCTestCase {

    public func testInitialization () {
        let vec1 = Vec3()
        XCTAssertEqual(3, vec1.dimension)
        XCTAssertEqual(3, vec1.components.count)
        XCTAssertEqual([0, 0, 0], vec1.components)
        XCTAssertEqual(0, vec1.x)
        XCTAssertEqual(0, vec1.y)
        XCTAssertEqual(0, vec1.z)

        let vec2 = Vec3(1, 2, 3)
        XCTAssertEqual([1, 2, 3], vec2.components)
        XCTAssertEqual(1, vec2.x)
        XCTAssertEqual(2, vec2.y)
        XCTAssertEqual(3, vec2.z)
        XCTAssertEqual(1, vec2[0])
        XCTAssertEqual(2, vec2[1])
        XCTAssertEqual(3, vec2[2])

        let vec3 = Vec3(components: [1, 2])
        XCTAssertEqual([1, 2, 0], vec3.components)

        let vec4 = Vec3(components: [5, 4, 3, 2, 1, 0])
        XCTAssertEqual(3, vec4.dimension)
        XCTAssertEqual(3, vec4.components.count)
        XCTAssertEqual([5, 4, 3], vec4.components)
    }

    public func testMethods () {
        let vec1 = Vec3(1, 2, 3)
        XCTAssertEqual(10, vec1.dot(Vec3(3, 2, 1)))
        XCTAssertEqual(14, vec1.dot(vec1))
        XCTAssertEqual(sqrt(14), vec1.length, accuracy: 0.0000001)
    }

    public func testOperators () {
        let lhs = Vec3(1, 2, 3)
        let rhs = Vec3(2, 4, 8)
        XCTAssertEqual([3, 6, 11], (lhs + rhs).components)
        XCTAssertNotEqual([4, 6, 11], (lhs + rhs).components)
        XCTAssertEqual([-1, -2, -3], (-lhs).components)
        XCTAssertEqual([-1, -2, -5], (lhs - rhs).components)
        XCTAssertEqual([1.5, 3, 4.5], (lhs * 1.5).components)
        XCTAssertEqual([1.5, 3, 4.5], (1.5 * lhs).components)
        XCTAssertEqual([0.5, 1, 1.5], (lhs / 2.0).components)
    }
}
