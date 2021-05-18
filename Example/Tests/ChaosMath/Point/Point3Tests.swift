//
//  Point3Tests.swift
//  Chaos_Tests
//
//  Created by Fu Lam Diep on 15.04.21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
@testable import ChaosMath

public class Point3Tests: XCTestCase {

    public func testInit () {
        let point = Point3(1, 2, 4)
        XCTAssertEqual(point.x, 1)
        XCTAssertEqual(point.y, 2)
        XCTAssertEqual(point.z, 4)
        XCTAssertEqual(point.components, [1, 2, 4])
    }

    public func testEmptyInit () {
        let point = Point3()
        XCTAssertEqual(point.x, 0)
        XCTAssertEqual(point.y, 0)
        XCTAssertEqual(point.z, 0)
    }

    public func testInitWithArray () {
        let p1 = Point3(components: [1])

        XCTAssertEqual(p1.x, 1)
        XCTAssertEqual(p1.y, 0)
        XCTAssertEqual(p1.z, 0)
        XCTAssertEqual(p1.components.count, 3)

        let p2 = Point3(components: [6, 5])

        XCTAssertEqual(p2.x, 6)
        XCTAssertEqual(p2.y, 5)
        XCTAssertEqual(p2.z, 0)
        XCTAssertEqual(p2.components.count, 3)
    }

    public func testEquatable () {
        let p1 = Point3(3, 4, 9)
        let p2 = Point3(components: [3, 4, 9])
        let p3 = Point3()

        XCTAssertEqual(p1, p2)
        XCTAssertNotEqual(p1, p3)
    }
}
