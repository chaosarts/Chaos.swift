//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 14.01.21.
//

import XCTest
@testable import ChaosCore

@objc public protocol Service {}
@objc public protocol OptionalService {}
@objc public protocol Injectable2: Resolvable {}

@objc public class BaseClass: NSObject {}
public class MyClass: Resolvable, Service {
    required public init () {}
}
public class YourClass: BaseClass, Resolvable {
    required public override init () {}
}
public class HisClass: OptionalService, Resolvable {
    public static let profile: String = "tmpDB"
    required public init () {}
}

public class HerClass: Injectable2, Service {
    public required init() {

    }
}


public class DependencyResolverTests: XCTestCase {
    let resolver: Resolver = .main

    public override func setUp() {
        super.setUp()
        resolver.scan()
    }

    public func testScan () {
        XCTAssertGreaterThanOrEqual(resolver.count, 3)
    }

    public func testCandidates () {
        let serviceTypes = resolver.candidates(Service.self)
        XCTAssertTrue(serviceTypes.contains(where: { $0 is MyClass.Type }))
        XCTAssertTrue(serviceTypes.contains(where: { $0 is HerClass.Type }))
        XCTAssertFalse(serviceTypes.contains(where: { $0 is YourClass.Type }))

        let services: [Service] = resolver.many(Service.self)
        XCTAssertTrue(services.contains(where: { $0 is MyClass }))
        XCTAssertTrue(services.contains(where: { $0 is HerClass }))
        XCTAssertFalse(services.contains(where: { $0 is YourClass }))

        var nilService: OptionalService? = resolver.optional(OptionalService.self)
        XCTAssertNil(nilService)

        resolver.setProfiles([HisClass.profile])
        resolver.scan()
        nilService = resolver.optional(OptionalService.self)
        XCTAssertNotNil(nilService)
    }
}
