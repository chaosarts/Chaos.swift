//
//  Point4Tests.swift
//  Chaos_Tests
//
//  Created by Fu Lam Diep on 15.04.21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
@testable import ChaosMath

public class Point4Tests: XCTestCase {

    public func testInit () {
        let point = Point4(1, 2, 4,18)
        XCTAssertEqual(point.x, 1)
        XCTAssertEqual(point.y, 2)
        XCTAssertEqual(point.z, 4)
        XCTAssertEqual(point.w, 18)
        XCTAssertEqual(point.components, [1, 2, 4, 18])
    }

    public func testEmptyInit () {
        let point = Point4()
        XCTAssertEqual(point.components.count, 4)
        XCTAssertEqual(point.x, 0)
        XCTAssertEqual(point.y, 0)
        XCTAssertEqual(point.z, 0)
        XCTAssertEqual(point.w, 0)
    }

    public func testInitWithArray () {
        let p1 = Point4(components: [1])
        XCTAssertEqual(p1.x, 1)
        XCTAssertEqual(p1.y, 0)
        XCTAssertEqual(p1.z, 0)
        XCTAssertEqual(p1.w, 0)
        XCTAssertEqual(p1.components.count, 4)

        let p2 = Point4(components: [6, 5])
        XCTAssertEqual(p2.x, 6)
        XCTAssertEqual(p2.y, 5)
        XCTAssertEqual(p2.z, 0)
        XCTAssertEqual(p2.w, 0)
        XCTAssertEqual(p2.components.count, 4)

        let p3 = Point4(components: [9, 7, 13])
        XCTAssertEqual(p3.x, 9)
        XCTAssertEqual(p3.y, 7)
        XCTAssertEqual(p3.z, 13)
        XCTAssertEqual(p3.w, 0)
        XCTAssertEqual(p3.components.count, 4)

        let p4 = Point4(components: [9, 7, 13, 108, 1])
        XCTAssertEqual(p4.x, 9)
        XCTAssertEqual(p4.y, 7)
        XCTAssertEqual(p4.z, 13)
        XCTAssertEqual(p4.w, 108)
        XCTAssertEqual(p4.components.count, 4)
    }

    public func testEquatable () {
        let p1 = Point4(3, 4, 9, 66)
        let p2 = Point4(components: [3, 4, 9, 66])
        let p3 = Point4()

        XCTAssertEqual(p1, p2)
        XCTAssertNotEqual(p1, p3)
    }
}
