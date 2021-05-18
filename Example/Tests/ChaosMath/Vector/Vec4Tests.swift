//
//  Vec4Tests.swift
//  Chaos_Example
//
//  Created by Fu Lam Diep on 12.04.21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
@testable import ChaosMath

public class Vec4Tests: XCTestCase {

    public func testInitialization () {
        let vec1 = Vec4()
        XCTAssertEqual(4, vec1.dimension)
        XCTAssertEqual(4, vec1.components.count)
        XCTAssertEqual([0, 0, 0, 0], vec1.components)
        XCTAssertEqual(0, vec1.x)
        XCTAssertEqual(0, vec1.y)
        XCTAssertEqual(0, vec1.z)
        XCTAssertEqual(0, vec1.w)

        let vec2 = Vec4(1, 2, 3, 4)
        XCTAssertEqual([1, 2, 3, 4], vec2.components)
        XCTAssertEqual(1, vec2.x)
        XCTAssertEqual(2, vec2.y)
        XCTAssertEqual(3, vec2.z)
        XCTAssertEqual(4, vec2.w)
        XCTAssertEqual(1, vec2[0])
        XCTAssertEqual(2, vec2[1])
        XCTAssertEqual(3, vec2[2])
        XCTAssertEqual(4, vec2[3])

        let vec3 = Vec4(components: [1, 2])
        XCTAssertEqual([1, 2, 0, 0], vec3.components)

        let vec4 = Vec4(components: [5, 4, 3, 2, 1, 0])
        XCTAssertEqual(4, vec4.dimension)
        XCTAssertEqual(4, vec4.components.count)
        XCTAssertEqual([5, 4, 3, 2], vec4.components)
    }

    public func testMethods () {
        let vec1 = Vec4(1, 2, 3, 4)
        XCTAssertEqual(20, vec1.dot(Vec4(4, 3, 2, 1)))
        XCTAssertEqual(30, vec1.dot(vec1))
        XCTAssertEqual(sqrt(30), vec1.length, accuracy: 0.0000001)
    }

    public func testOperators () {
        let lhs = Vec4(1, 2, 3, 4)
        let rhs = Vec4(2, 4, 8, 12)
        XCTAssertEqual([3, 6, 11, 16], (lhs + rhs).components)
        XCTAssertNotEqual([4, 6, 11, 16], (lhs + rhs).components)
        XCTAssertEqual([-1, -2, -3, -4], (-lhs).components)
        XCTAssertEqual([-1, -2, -5, -8], (lhs - rhs).components)
        XCTAssertEqual([1.5, 3, 4.5, 6], (lhs * 1.5).components)
        XCTAssertEqual([1.5, 3, 4.5, 6], (1.5 * lhs).components)
        XCTAssertEqual([0.5, 1, 1.5, 2], (lhs / 2.0).components)
    }
}
