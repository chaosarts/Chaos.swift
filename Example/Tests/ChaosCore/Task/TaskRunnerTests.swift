//
//  TaskRunnerTest.swift
//  Chaos_Tests
//
//  Created by Fu Lam Diep on 22.10.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
@testable import Chaos

public class TaskRunnerTests: XCTestCase {
    
    public override func setUp () {
        super.setUp()
    }

    public func testNoTaskSource () {
        let expectation = self.expectation(description: "Task Runner")
        TaskRunner().start().catch({ _ throws -> Void in expectation.fulfill() })
        waitForExpectations(timeout: 2)
    }
}
