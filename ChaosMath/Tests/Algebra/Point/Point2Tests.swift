//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 19.02.22.
//

import XCTest
@testable import ChaosMath

public class Point2Tests: XCTestCase {

    public func testInit_containsCorrectValues () {

        // Act
        let point1 = Point2()
        let point2 = Point2(components: [])
        let point3 = Point2(components: [1])
        let point4 = Point2(components: [2, 3])
        let point5 = Point2(components: [2, 3, 4])

        // Assert
        XCTAssertEqual(point1.components.count, 2)
        XCTAssertEqual(point1.x, 0)
        XCTAssertEqual(point1.y, 0)

        XCTAssertEqual(point2.components.count, 2)
        XCTAssertEqual(point2.x, 0)
        XCTAssertEqual(point2.y, 0)

        XCTAssertEqual(point3.components.count, 2)
        XCTAssertEqual(point3.x, 1)
        XCTAssertEqual(point3.y, 0)

        XCTAssertEqual(point4.components.count, 2)
        XCTAssertEqual(point4.x, 2)
        XCTAssertEqual(point4.x, point4.components[0])
        XCTAssertEqual(point4.y, 3)
        XCTAssertEqual(point4.y, point4.components[1])

        XCTAssertEqual(point5.components.count, 2)
        XCTAssertEqual(point5.x, 2)
        XCTAssertEqual(point5.x, point5.components[0])
        XCTAssertEqual(point5.y, 3)
        XCTAssertEqual(point5.y, point5.components[1])
    }
}
