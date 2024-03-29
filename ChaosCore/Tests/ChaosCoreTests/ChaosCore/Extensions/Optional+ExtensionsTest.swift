//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 29.01.22.
//

import XCTest
@testable import ChaosCore

public class OptionalExtensionsTests: XCTestCase {

    public func testSetIfNil_setsValue_whenOptionalIsNil () {
        // Act
        var optional: String?
        optional.setIfNil("Mom")

        // Assert
        XCTAssertEqual(optional, "Mom")
    }

    public func testSetIfNil_setsNotValue_whenOptionalIsNotNil () {
        // Act
        var optional: String? = "Dad"
        optional.setIfNil("Mom")

        // Assert
        XCTAssertEqual(optional, "Dad")
    }
}
