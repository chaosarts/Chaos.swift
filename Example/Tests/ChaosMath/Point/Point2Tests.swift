//
//  Point2Tests.swift
//  Chaos_Tests
//
//  Created by Fu Lam Diep on 15.04.21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
@testable import ChaosMath

public class Point2Tests: XCTestCase {

    public func testInit () {
        let point = Point2(1, 2)
        XCTAssertEqual(point.x, 1)
        XCTAssertEqual(point.y, 2)
        XCTAssertEqual(point.components, [1, 2])
    }

    public func testEmptyInit () {
        let point = Point2()
        XCTAssertEqual(point.x, 0)
        XCTAssertEqual(point.y, 0)
    }

    public func testInitWithArray () {
        let p1 = Point2(components: [1])

        XCTAssertEqual(p1.x, 1)
        XCTAssertEqual(p1.y, 0)
        XCTAssertEqual(p1.components.count, 2)

        let p2 = Point2(components: [6, 5, 4])

        XCTAssertEqual(p2.x, 6)
        XCTAssertEqual(p2.y, 5)
        XCTAssertEqual(p2.components.count, 2)
    }

    public func testEquatable () {
        let p1 = Point2(3, 4)
        let p2 = Point2(components: [3, 4])
        let p3 = Point2()

        XCTAssertEqual(p1, p2)
        XCTAssertNotEqual(p1, p3)
    }
}
