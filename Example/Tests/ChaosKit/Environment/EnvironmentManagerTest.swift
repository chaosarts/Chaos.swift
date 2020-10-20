//
//  EnvironmentManagerTest.swift
//  Chaos_Tests
//
//  Created by Fu Lam Diep on 19.10.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import ChaosCore
@testable import ChaosKit

public class TestEnvironment: Environment, Decodable {

    public var identifier: String
    
    public var title: String?
    
    public var description: String?
    
    public func numberOfEnvironmentSetupTasks() -> Int {
        1
    }
    
    public func environmentSetupTask(at index: Int) -> EnvironmentSetupTask {
        TestEnvironmentSetupTask(environment: self)
    }
    
    public func configuration<Config>(at path: [String]) -> Config? {
        nil
    }
}

public class TestEnvironmentSetupTask: EnvironmentSetupTask {
    public let environment: Environment

    public var title: String = "Loading Stops"

    public var description: String?

    public init (environment: Environment) {
        self.environment = environment
    }

    public func run() -> Promise<Void> {
        Promise<Void>()
    }
}

public class EnvironmentManagerTest: XCTestCase {

    private var environmentManager: EnvironmentManager = .instance

    public override class func setUp() {
        super.setUp()
    }
}
