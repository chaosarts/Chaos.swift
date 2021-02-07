//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 18.01.21.
//

import XCTest
@testable import ChaosCore

class StringTests: XCTestCase {

    func testExtract () throws {
        let comExtraction = try "https://www.google.com#main".extract(withPattern: "^((https?:)?//)?([^/\\?#]+)(/[^\\?#]*)?(\\?([^#]*))?(#(.*))?");
        XCTAssertEqual(comExtraction.count, 1)
        XCTAssertEqual(comExtraction[0].count, 6)
    }
}
