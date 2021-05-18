//
//  DynamicVector.swift
//  Chaos_Tests
//
//  Created by Fu Lam Diep on 18.04.21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
@testable import ChaosMath

public class DynamicVectorTests: XCTestCase {

    public func testInit () {
        var vector = DynamicVector(components: [1.2, 3.4])
        XCTAssertEqual(vector.dimension, 2)
        XCTAssertEqual(vector.dimension, vector.components.count)
        XCTAssertEqual(vector[0], 1.2)
        XCTAssertEqual(vector[1], 3.4)
        XCTAssertEqual(vector[0], vector.components[0])
        XCTAssertNotEqual(vector[0], vector.components[1])

        let randomCount = Int.random(in: 2...10)
        vector = DynamicVector(components: Array(repeating: 0.0, count: randomCount))
        XCTAssertEqual(randomCount, vector.dimension)
    }

    public func testDot () {
        let vec1 = DynamicVector(components: [1.2, 3.5, -9.8])
        let vec2 = DynamicVector(components: [-0.9, 8.2, 6.3])

        XCTAssertEqual(vec1.length, 10.4752088285, accuracy: 0.000000001)
        XCTAssertEqual(vec1.dot(vec2), -34.12, accuracy: 0.00001)
    }
}
