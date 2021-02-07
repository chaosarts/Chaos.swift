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
@objc public protocol A {}
@objc public protocol B {}

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

public class SingletonClass: A, Resolvable {
    public static var singleton: Bool { true }
    public required init () {}
}


public class Singleton: B, Resolvable {
    public static var singleton: Bool { return true }
    public required init () {}
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


    public func testSingleton () {
        let a: A = resolver.one(A.self)
        let b: A = resolver.one(A.self)
        XCTAssertEqual(NSStringFromClass(type(of: a)), NSStringFromClass(type(of: b)))
        XCTAssertTrue(a === b)

        let c: OptionalService = resolver.one(OptionalService.self)
        let d: OptionalService = resolver.one(OptionalService.self)
        XCTAssertEqual(NSStringFromClass(type(of: c)), NSStringFromClass(type(of: d)))
        XCTAssertTrue(c !== d)

        let e: B = resolver.one(B.self)
        XCTAssertTrue(a !== e)
    }
}
