//
//  Copyright © 2024 Fu Lam Diep <fulam.diep@gmail.com>
//

import Foundation

public struct Validator<Key, Value> {
    public let key: Key
    public let rules: [any Rule<Value>]
    public func validate<Data>(_ data: Data) async where Data: Collection, Data.Index == Key, Data.Element == Value {
        guard data.indices.contains(key) else {
            return
        }
        for rule in rules {
            let accepted = await rule.accepts(data[key])
        }
    }
}
