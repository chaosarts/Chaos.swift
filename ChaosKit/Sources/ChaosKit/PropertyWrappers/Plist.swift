#if canImport(UIKit)
//
//  Plist.swift
//  ChaosKit
//
//  Created by Fu Lam Diep on 22.10.20.
//

import UIKit
import ChaosCore

@propertyWrapper
public struct Plist<Value: Decodable> {

    public var wrappedValue: Value

    public init (key: String, plist: String = "Info", in bundle: Bundle = .main) {
        guard let path = bundle.path(forResource: plist, ofType: "plist"),
              let data = FileManager.default.contents(atPath: path) else {
            fatalError("Could not find plist file '\(plist)' or get contents of it.")
        }

        let keyPath = key.split(separator: ".").map(String.init)
        guard let decoder = try? PropertyListDecoder().decode(DeferredDecoder.self, from: data),
              let wrappedValue = try? decoder.decode(Value.self, keyPath: keyPath) else {
            fatalError("Unable to decode value at key path '\(key)' in plist file '\(path)'")
        }
        
        self.wrappedValue = wrappedValue
    }
}

#endif