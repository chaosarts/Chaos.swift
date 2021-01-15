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
/// environment (`@objc`). To resolve such a protocol, ther must be at least one
/// class in the project that conforms to this protocol on the one hand, but also
/// conforms to the protocol `Injectable` to be detected by the resolvers scan
/// method.
public final class Resolver {

    // MARK: Properties

    /// Provides the set of active profiles. Injectable classes may specify the
    /// static property `profile` or `profiles` to indicate that these classes
    /// are available for resolution when at least one profile is contained in
    /// this set.
    public private(set) var profiles: Set<String> = Set()

    /// Provides the count of injectable types found by the scan method.
    public var count: Int { injectableTypes.count }

    /// Provides the list of all types that conforms to the `Injectable` protocol.
    private let injectableTypes: [Resolvable.Type]

    /// Provides a filtered list of injectable types according to the list of
    /// active profiles.
    private var activeInjectableTypes: [Resolvable.Type] = []

    /// Indicates, whether the resolver needs an update or not. This may be true
    /// before the very first call of scan within an application lifecycle or
    /// after `setProfiles(_:)` has been called.
    private var needsUpdate: Bool = true


    // MARK: Initialization

    /// Initalizes the resolver.
    private init () {
        injectableTypes = class_getInjectables()
    }


    // MARK: Managing Profiles

    /// Sets the profiles to activate, this list will indicate which injectables
    public func setProfiles (_ profiles: [String]) {
        self.profiles = Set(profiles)
        needsUpdate = true
    }


    // MARK: Scanning for Injectables

    /// Scans the project for injectable classes according to the list of active
    /// profiles and stores the list in a temporary list. This method needs to be
    /// called before using the resolver or after setting the profiles.
    @discardableResult
    public func scan () -> Int {
        guard needsUpdate else { return injectableTypes.count }
        activeInjectableTypes = injectableTypes.filter({
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

        needsUpdate = false
        return injectableTypes.count
    }


    // MARK: Resolving Candidates

    /// Returns the list of candidates for the given protocol to resolve. This is
    /// a common function used by resolver methods `one`, `many`, `some`, to
    /// have a unified filter method.
    internal func candidates (_ protocol: Protocol) -> [Resolvable.Type] {
        activeInjectableTypes.filter({
            ChaosCore.class_conformsToProtocol($0, `protocol`)
        })
    }

    /// Attempts to resolve the given protocol to an instance. This method is used
    /// to require a type. The method fails with an `fatalError`, if either more
    /// than one or no candidate has been found.
    public func one<T> (_ protocol: Protocol) -> T {
        guard let instance: T = some(`protocol`) else {
            fatalError("Resolving dependency failed: No candidate found.")
        }
        return instance
    }

    /// Attempts to resolve the given protocol as a list of instances.
    public func many<T> (_ protocol: Protocol) -> [T] {
        return self.candidates(`protocol`)
            .map({ $0.init() as! T })
    }

    /// Attepmts to resolve the given protocol to an instance. If more than one
    /// classes are found, this method wil fail in an `fatalError`.
    public func some<T> (_ protocol: Protocol) -> T? {
        let candidates = self.candidates(`protocol`)
        if candidates.count > 0 {
            fatalError("Resolving dependency failed: Candidate is ambigous (\(candidates.count)).")
        }
        return candidates.first?.init() as? T
    }
}


// MARK: - Static Properties

public extension Resolver {
    static let main = Resolver()
    static func scan () -> Int { main.scan() }
    static func one<T> (_ proto: Protocol) -> T { main.one(proto) }
    static func many<T> (_ proto: Protocol) -> [T] { main.many(proto) }
    static func some<T> (_ proto: Protocol) -> T? { main.some(proto) }
}
