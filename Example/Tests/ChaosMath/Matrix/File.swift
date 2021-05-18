//
//  File.swift
//  Chaos_Tests
//
//  Created by Fu Lam Diep on 18.04.21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
@testable import ChaosMath

public class Mat4Tests {

    public func testInit () {

        XCTAssertEqual(Mat4.dimension, 4)
        XCTAssertEqual(Mat4.shape.0, 4)
        XCTAssertEqual(Mat4.shape.1, 4)

        let mat1 = Mat4(components: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16])
        XCTAssertEqual(mat1.dimension, 4)
        XCTAssertEqual(mat1.shape.0, 4)
        XCTAssertEqual(mat1.shape.1, 4)
        XCTAssertEqual(mat1.components, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16])

        for row in 0..<mat1.shape.0 {
            for col in 0..<mat1.shape.1 {
                XCTAssertEqual(mat1[row, col], mat1.components[row * mat1.shape.1 + col])
                XCTAssertEqual(mat1[row, col], mat1.component(at: row * mat1.shape.1 + col))
            }
        }

        XCTAssertEqual(mat1[row: 0], Vec4(1, 2, 3, 4))
        XCTAssertEqual(mat1[col: 0], Vec4(1, 5, 9, 13))

        let mat2 = Mat4(components: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12])
        XCTAssertEqual(mat2.components.count, 16)
        XCTAssertEqual(mat2.components, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 0, 0, 0, 0])

        let mat3 = Mat4(components: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18])
        XCTAssertEqual(mat3.components.count, 16)
        XCTAssertEqual(mat3.components, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16])

        let mat4 = Mat4(a11: 2, a22: 4, a33: 1, a44: 9)
        let check: [Float] = [2, 4, 1, 9]
        XCTAssertEqual(mat4.components.count, 16)
        for row in 0..<mat4.shape.0 {
            for col in 0..<mat4.shape.1 {
                if row == col {
                    XCTAssertEqual(mat4[row, col], check[row])
                } else {
                    XCTAssertEqual(mat4[row, col], 0)
                }
            }
        }
    }
}
