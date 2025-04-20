//
//  Copyright © 2024 Fu Lam Diep <fulam.diep@gmail.com>
//

import Foundation

public func exclusiveScan<Data, Value>(_ data: Data, keyPath: KeyPath<Data.Element, Value>) -> [Value]
where Data: RandomAccessCollection, Value: AdditiveArithmetic & ExpressibleByIntegerLiteral {
    guard !data.isEmpty else {
        return []
    }
    
    let values = data.map { $0[keyPath: keyPath] }.dropLast()
    var prefixSums: [Value] = [0]
    for value in values {
        prefixSums.append(value + prefixSums.last!)
    }
    return prefixSums
}

public func exclusiveScan<Data>(_ data: Data) -> [Data.Element]
where Data: RandomAccessCollection, Data.Element: AdditiveArithmetic & ExpressibleByIntegerLiteral {
    exclusiveScan(data, keyPath: \.self)
}


public func inclusiveScan<Data, Value>(_ data: Data, keyPath: KeyPath<Data.Element, Value>) -> [Value]
where Data: RandomAccessCollection, Value: AdditiveArithmetic & ExpressibleByIntegerLiteral {
    var output = Array<Value>()
    var data = Array(data)
    while !data.isEmpty {
        let value = data.first![keyPath: keyPath]
        data = Array(data.dropFirst())
        output.append((output.last ?? 0) + value)
    }
    return output
}

public func inclusiveScan<Data>(_ data: Data) -> [Data.Element]
where Data: RandomAccessCollection, Data.Element: AdditiveArithmetic & ExpressibleByIntegerLiteral {
    inclusiveScan(data, keyPath: \.self)
}

public func scan<Data, Value>(_ data: Data, keyPath: KeyPath<Data.Element, Value>, inclusive: Bool = true) -> [Value]
where Data: RandomAccessCollection, Value: AdditiveArithmetic & ExpressibleByIntegerLiteral {
    inclusive ? inclusiveScan(data, keyPath: keyPath) : exclusiveScan(data, keyPath: keyPath)
}

public func scan<Data>(_ data: Data, inclusive: Bool = true) -> [Data.Element]
where Data: RandomAccessCollection, Data.Element: AdditiveArithmetic & ExpressibleByIntegerLiteral {
    scan(data, keyPath: \.self, inclusive: inclusive)
}
