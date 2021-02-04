//
//  EnvironmentManagerTest.swift
//  Chaos_Tests
//
//  Created by Fu Lam Diep on 19.10.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
@testable import ChaosCore
@testable import ChaosKit

public class EnvironmentManagerTest: XCTestCase, EnvironmentManagerDelegate {

    private var environmentManager: EnvironmentManager = .instance

    private var bundle: Bundle = Bundle(for: EnvironmentManagerTest.self)

    public override func setUp() {
        super.setUp()
        environmentManager.delegate = self
    }

    public func testLoadingEnvironmemnts () {
        do {
            try environmentManager.loadEnvironments(ofType: TestEnvironment.self,
                                                    fromFile: "missing-file",
                                                    in: bundle)
            XCTFail("Unexpected success.")
        } catch (let error as EnvironmentError) {
            XCTAssertEqual(error.code, .environmentsFileNotFound)
        } catch {
            XCTFail("Unexpected error type.")
        }

        do {
            try environmentManager.loadEnvironments(ofType: TestEnvironment.self,
                                                    fromFile: "missing-fields",
                                                    in: bundle)
            XCTFail("Unexpected success.")
        } catch (let error as EnvironmentError) {
            XCTAssert(error.previous is DecodingError)
        } catch {
            XCTFail("Unexpected error type.")
        }

        do {
            try environmentManager.loadEnvironments(ofType: TestEnvironment.self,
                                                    fromFile: "single-environment",
                                                    in: bundle)
            XCTAssertGreaterThan(environmentManager.numberOfEnvironments, 0)
        } catch {
            XCTFail("Unexpected error type.")
        }

        do {
            try environmentManager.loadEnvironments(ofType: TestEnvironment.self,
                                                    fromFile: "multiple-environments",
                                                    in: bundle)
            XCTAssertGreaterThan(environmentManager.numberOfEnvironments, 0)
        } catch {
            XCTFail("Unexpected error type.")
        }
    }


    public func testAccessEnvironments () {
        do {
            try environmentManager.loadEnvironments(ofType: TestEnvironment.self,
                                                    fromFile: "single-environment",
                                                    in: bundle)
        } catch {
            XCTFail(error.localizedDescription)
        }

        XCTAssertEqual(environmentManager.numberOfEnvironments, 1)
        XCTAssertEqual(environmentManager.environmentIdentifier(at: 0), "chaos-prod")
    }


    public func testSetupEnvironmentSingle () {
        environmentManager.removeSelection()

        do {
            try environmentManager.loadEnvironments(ofType: TestEnvironment.self,
                                                    fromFile: "single-environment",
                                                    in: bundle)
        } catch {
            XCTFail(error.localizedDescription)
        }

        environmentManager.delegate = self
        XCTAssert(environmentManager.delegate === self)
        let autoSelectExpectation = expectation(description: "AutoSelect")
        environmentManager.autoSelect()
            .then({ autoSelectExpectation.fulfill() })

        waitForExpectations(timeout: 2)

        XCTAssertEqual(environmentManager.selectedEnvironmentIdentifier, "chaos-prod")
    }

    public func testSetupEnvironmentMultiple () {
        environmentManager.removeSelection()
        
        do {
            try environmentManager.loadEnvironments(ofType: TestEnvironment.self,
                                                    fromFile: "multiple-environments",
                                                    in: bundle)
        } catch {
            XCTFail(error.localizedDescription)
        }

        environmentManager.delegate = self
        XCTAssert(environmentManager.delegate === self)
        let autoSelectExpectation = expectation(description: "AutoSelect")
        environmentManager.autoSelect()
            .catch({ _ in autoSelectExpectation.fulfill() })

        waitForExpectations(timeout: 2)
    }

    public func environmentManager(_ environmentManager: EnvironmentManager, didSelectEnvironment environment: Environment) {

    }

    public func environmentManager(_ environmentManager: EnvironmentManager, didSetupEnvironment environment: Environment, withError error: Error?) {

    }

    public func environmentManager(_ environmentManager: EnvironmentManager, willRunSetupTask task: EnvironmentSetupTask, for environment: Environment) {

    }

    public func environmentManager(_ environmentManager: EnvironmentManager, didFinishSetupTask task: EnvironmentSetupTask, withError error: Error?, for environment: Environment) {

    }
}



public class TestEnvironment: Environment {

    public var identifier: String

    public var title: String?

    public var description: String?

    public var date: Date

    public var number: Int

    public func numberOfEnvironmentSetupTasks() -> Int {
        3
    }

    public func environmentSetupTask(at index: Int) -> EnvironmentSetupTask {
        TestEnvironmentSetupTask(title: "Task \(index)", detailText: "Blabla") { (task, env) -> Promise<Void> in
            return Promise()
        }
    }

    public func configuration<Config>(at path: [String]) -> Config? {
        nil
    }
}

public class TestEnvironmentSetupTask: EnvironmentSetupTask {

    public let title: String

    public let detailText: String?

    private let work: (EnvironmentSetupTask, Environment) -> Promise<Void>

    public init (title: String, detailText: String? = nil, work: @escaping (EnvironmentSetupTask, Environment) -> Promise<Void>) {
        self.title = title
        self.detailText = detailText
        self.work = work
    }

    public func run(for environment: Environment) -> Promise<Void> {
        work(self, environment)
    }
}
