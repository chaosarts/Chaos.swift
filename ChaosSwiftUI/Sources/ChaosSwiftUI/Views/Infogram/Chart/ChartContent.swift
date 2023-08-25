//
//  File.swift
//  
//
//  Created by fu.lam.diep on 29.07.23.
//

import Foundation

public protocol ChartContent {
    associatedtype Body: ChartContent
    var body: Self.Body { get }
}

extension ChartContent {
    var isNever: Bool { Body.self == Never.self }
}

public extension ChartContent where Body == Never {
    var body: Never { fatalError() }
}

extension Never: ChartContent {
    public typealias Body = Never
}

extension Optional: ChartContent where Wrapped: ChartContent {
    public typealias Body = Never
}
