//
//  Globals.swift
//  ChaosCore
//
//  Created by Fu Lam Diep on 23.10.20.
//

import Foundation

public func identity<V> (_ value: V) -> V { value }

public func moduleName<T: AnyObject> (_ any: T.Type) -> String {
    guard let moduleName = NSStringFromClass(any).split(separator: ".").first else { fatalError("Module name cannot be extracted from type '\(any)'") }
    return String(moduleName)
}

public func bla() -> String {
    #if BLA
    return "BLA"
    #else
    return "NO BLA"
    #endif
}

public func configuration() -> String {
    #if DEBUG
    return "Debug"
    #else
    return "Unknown"
    #endif
    #if RELEASE
    return "Release"
    #endif
}
