//
//  File.swift
//  
//
//  Created by fu.lam.diep on 01.08.23.
//

import Foundation

public struct LineMark: ChartContent {
    public init<X, Y>(_ x: PlottableValue<X>, _ y: PlottableValue<Y>) {
        
    }
}

public struct PlottableValue<Value> where Value: Plottable {

    private let value: Value

    public static func value<S>(_ label: S, _ value: Value) -> Self where S: StringProtocol {
        Self.init(value: value)
    }
}

public protocol Plottable {
    associatedtype PrimitivePlottable: PrimitivePlottableProtocol
    var primitivyPlottable: Self.PrimitivePlottable { get }
    init?(primitivPlottable: Self.PrimitivePlottable)
}

public protocol PrimitivePlottableProtocol: Plottable where Self == Self.PrimitivePlottable {
}

extension Double: PrimitivePlottableProtocol {
    public var primitivyPlottable: Double {
        self
    }

    public init?(primitivPlottable: Double) {
        self = primitivPlottable
    }
}

extension Date: PrimitivePlottableProtocol {
    public var primitivyPlottable: Date {
        self
    }

    public init?(primitivPlottable: Date) {
        self = primitivPlottable
    }
}
