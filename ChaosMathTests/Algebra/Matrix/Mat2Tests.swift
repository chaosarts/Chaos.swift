//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 20.02.22.
//

import XCTest
@testable import ChaosMath

public class Mat2Tests: XCTestCase {

    public func testInit_isZeroMatrix_whenNoArgumentsPassed() {
        // Act
        let matrix = Mat2()
        XCTAssertEqual(matrix, .zero)
    }
}
