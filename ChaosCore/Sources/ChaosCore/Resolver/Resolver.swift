//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 14.01.21.
//

import Foundation

/// A dependency resolver class, that automtically finds the class that conforms
/// a given protocol and creates an instance of it.
///
/// If a property is declared with a protocol type, this class can be used to
/// assign the initial value.
///
/// Requirements: The protocol to be resolved must be visible to the Objective-C
/// environment (`@objc`). To resolve such a protocol, there must be at least one
/// class in the project that conforms to this protocol on the one hand, but also
/// conforms to the protocol `Injectable` to be detected by the resolvers scan
/// method.
///
/// When trying to use the resolver method `one`, `many` or `optional`, the
/// type specified by the generic parameter should be the same as the `Protocol`
/// type passed to the method. E.g.:
///
/// ```
/// var service: Service = Resolver.one(Service.self)
/// var services: [Service] = Resolver.many(Service.self)
/// var service: Service? = Resolver.optional(Service.self)
/// ```
/// - Note: It is recommended to use the same protocol type for both, the generic
/// type and the type passed to the method. Unfortunatley generic and meta types
/// cannot be put into relation with type `Protocol`. But `Protocol` is needed to
/// limit the type to pass to the methods and to check for protocol conformance.
/// Hence the relation between the generic type and the type passed to the method
/// cannot be checked at compile time.
///
/// - TODO: Implement mechanism for singletons/cache and named instances
public final class Resolver {

    // MARK: Properties

    /// Provides the set of active profiles. Injectable classes may specify the
    /// static property `profile` or `profiles` to indicate that these classes
    /// are available for resolution when at least one profile is contained in
    /// this set.
    public private(set) var profiles: Set<String> = Set()

    /// Provides the count of injectable types found by the scan method.
    public var count: Int { resolvableTypes.count }

    /// Provides the list of all types that conforms to the `Injectable` protocol.
    private let resolvableTypes: [Resolvable.Type]

    /// Provides a filtered list of injectable types according to the list of
    /// active profiles.
    private var activeResolvableTypes: [Resolvable.Type] = []

    /// Indicates, whether the resolver needs an update or not. This may be true
    /// before the very first call of scan within an application lifecycle or
    /// after `setProfiles(_:)` has been called.
    private var needsUpdate: Bool = true

    /// Provides a dictionary of resolvable instances where key is the fully
    /// qualified class name of the instance itself. This dictionary is used to
    /// store resolvables that are marked as singleton.
    private var resolvablesByKey: [String: Resolvable] = [:]


    // MARK: Initialization

    /// Initalizes the resolver.
    private init () {
        resolvableTypes = class_getResolvables()
    }


    // MARK: Managing Profiles

    /// Sets the list of profiles to indicate which implementation to use when
    /// resolving classes. This will also invoke `scan()`.
    public func setProfiles (_ profiles: [String]) {
        self.profiles = Set(profiles)
        needsUpdate = true
        scan()
    }


    // MARK: Scanning for Injectables

    /// Scans the project for injectable classes according to the list of active
    /// profiles and stores them in a temporary list. This method needs to be
    /// called before using the resolver or after setting the profiles.
    @discardableResult
    public func scan (flushCache: Bool = false) -> Int {
        guard needsUpdate else {
            return resolvableTypes.count
        }

        activeResolvableTypes = resolvableTypes.filter({
            if let profile = $0.profile {
                return profiles.contains(profile) || profile.isEmpty
            }

            if let profiles = $0.profiles {
                return profiles.contains { profile in
                    self.profiles.contains(profile) || profile.isEmpty
                }
            }
            return true
        })

        if flushCache {
            self.flushCache()
        }

        needsUpdate = false
        return resolvableTypes.count
    }

    /// Flushes the cache of singletons
    public func flushCache () {
        resolvablesByKey = [:]
    }


    // MARK: Resolving Candidates

    /// Returns the list of candidates for the given protocol to resolve. This is
    /// a common function used by resolver methods `one`, `many`, `some`, to
    /// have a unified filter method.
    internal func candidates (_ proto: Protocol) -> [Resolvable.Type] {
        if needsUpdate {
            fatalError("Fetching candidates failed: scan() needs to be " +
                        "invoked before use or after calling setProfiles()")
        }

        return activeResolvableTypes.filter({
            ChaosCore.class_conformsToProtocol($0, proto)
        })
    }

    /// Attempts to resolve the given protocol to an instance. This method is used
    /// to require a type. The method fails with an `fatalError`, if either more
    /// than one or no candidate has been found.
    public func one<T> (_ proto: Protocol) -> T {
        guard let instance: T = optional(proto) else {
            fatalError("Resolving dependency failed: No candidate found.")
        }
        return instance
    }

    /// Returns a list of instances of each class conforming the given protocol.
    public func many<T> (_ proto: Protocol) -> [T] {
        return self.candidates(proto)
            .map({
                guard let instance = build($0) as? T else {
                    fatalError("Resolving dependency failed: unable to " +
                                "downcast resolvable '\($0.self)' to type \(T.self)")
                }
                return instance
            })
    }

    /// Attempts to resolve the given protocol to the implicit type T. This method
    /// fails with `fatalError()`, if either the type to resolve is ambigous or
    /// the given protocol is unrelated to the implicit type T.
    public func optional<T> (_ proto: Protocol) -> T? {
        let candidates = self.candidates(proto)

        // Ambigous type
        if candidates.count > 1 {
            fatalError("Resolving dependency failed: Candidate is ambigous " +
                        "(\(candidates.count)).")
        }

        // No class found, but thats okay, since this is optional
        guard let first = candidates.first else {
            return nil
        }

        // Types are unrelated
        guard let instance = build(first) as? T else {
            fatalError("Resolving dependency failed: given protocol and type " +
                        "'\(T.self)' are unrelated.")
        }
        return instance
    }

    /// Builds the according instance to the given class passed. If the type
    /// responds to `singleton` with true, the method tries to get the instance
    /// from cache and if it fails it creates a new instance at put it into cache.
    private func build (_ type: Resolvable.Type) -> Resolvable {
        guard type.singleton == true else { return type.init() }
        let key = NSStringFromClass(type)
        return resolvablesByKey.insertIfNotExists(type.init(), forKey: key)
    }
}


// MARK: - Static Properties

public extension Resolver {
    static let main = Resolver()
    static func scan () -> Int { main.scan() }
    static func one<T> (_ proto: Protocol) -> T { main.one(proto) }
    static func many<T> (_ proto: Protocol) -> [T] { main.many(proto) }
    static func some<T> (_ proto: Protocol) -> T? { main.optional(proto) }
}


