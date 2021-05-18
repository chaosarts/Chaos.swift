//
//  Vec2Tests.swift
//  Chaos_Example
//
//  Created by Fu Lam Diep on 12.04.21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
@testable import ChaosMath

public class Vec2Tests: XCTestCase {

    public func testInitialization () {
        let vec1 = Vec2()
        XCTAssertEqual(2, vec1.dimension)
        XCTAssertEqual(2, vec1.components.count)
        XCTAssertEqual([0, 0], vec1.components)
        XCTAssertEqual(0, vec1.x)
        XCTAssertEqual(0, vec1.y)

        let vec2 = Vec2(1, 2)
        XCTAssertEqual([1, 2], vec2.components)
        XCTAssertEqual(1, vec2.x)
        XCTAssertEqual(2, vec2.y)
        XCTAssertEqual(1, vec2[0])
        XCTAssertEqual(2, vec2[1])

        let vec3 = Vec2(components: [1, 2])
        XCTAssertEqual([1, 2], vec3.components)

        let vec4 = Vec2(components: [5, 4, 3, 2, 1, 0])
        XCTAssertEqual(2, vec4.dimension)
        XCTAssertEqual(2, vec4.components.count)
        XCTAssertEqual([5, 4], vec4.components)
    }

    public func testMethods () {
        let vec1 = Vec2(2, 2)
        XCTAssertEqual(10, vec1.dot(Vec2(3, 2)))
        XCTAssertEqual(8, vec1.dot(vec1))
        XCTAssertEqual(sqrt(8), vec1.length, accuracy: 0.0000001)

        let vec2 = Vec2(3, 4)
        XCTAssertEqual(vec2.normal(), Vec2(4, -3))
        
    }

    public func testOperators () {
        let lhs = Vec2(1, 2)
        let rhs = Vec2(2, 4)
        XCTAssertEqual([3, 6], (lhs + rhs).components)
        XCTAssertNotEqual([4, 6], (lhs + rhs).components)
        XCTAssertEqual([-1, -2], (-lhs).components)
        XCTAssertEqual([-1, -2], (lhs - rhs).components)
        XCTAssertEqual([1.5, 3], (lhs * 1.5).components)
        XCTAssertEqual([1.5, 3], (1.5 * lhs).components)
        XCTAssertEqual([0.5, 1], (lhs / 2.0).components)
    }
}
