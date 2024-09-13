//
//  Copyright © 2024 Fu Lam Diep <fulam.diep@gmail.com>
//

import Foundation

/**
 A property wrapper to make properties in a view capturable by clsoures in ``navigationDestination``.

 In iOS 16 the content closure of `navigationDestination` leads to app freezes, when values are captured, that are not
 equatable. This is mainly meant to be used for closures, since they are not extensible to the `Equatable` protocol.
 */
@propertyWrapper
public struct Capturable<Value> {

    public var wrappedValue: Value

    public var projectedValue: Self {
        self
    }

    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
}

extension Capturable: Equatable {
    public static func == (lhs: Capturable<Value>, rhs: Capturable<Value>) -> Bool {
        true
    }
}

extension Capturable where Value: Equatable {
    public static func == (lhs: Capturable<Value>, rhs: Capturable<Value>) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}
