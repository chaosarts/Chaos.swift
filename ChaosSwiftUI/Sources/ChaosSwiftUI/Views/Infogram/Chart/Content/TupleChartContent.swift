//
//  File.swift
//  
//
//  Created by fu.lam.diep on 29.07.23.
//

import Foundation

public struct TupleChartContent<T>: ChartContent {
    public typealias Body = Never
    public let value: T
    @inlinable public init(_ value: T) {
        self.value = value
    }
}
