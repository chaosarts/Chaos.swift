//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 12.04.22.
//

import Foundation
import SwiftUI

public protocol Tic {
    var position: Float { get }

    func path(at point: CGPoint, axis: Axis) -> Path
}

public protocol TicConfiguration {

    var numberOfXtics: Int { get }

    var numberOfYtics: Int { get }

    func xtic(at index: Int) -> Tic

    func ytic(at index: Int) -> Tic
}

public struct EuclideanCoordinateSystem: Shape {

    private let xrange: Range<Float>

    private let yrange: Range<Float>

    private let ticConfiguration: TicConfiguration

    public init(xrange: Range<Float> = -1..<1, yrange: Range<Float> = -1..<1, tics: TicConfiguration) {
        self.xrange = xrange
        self.yrange = yrange
        self.ticConfiguration = tics
    }

    public func path(in rect: CGRect) -> Path {
        var main = Path()

        for index in 0..<ticConfiguration.numberOfXtics {
            let tic = ticConfiguration.xtic(at: index)
        }

        return main
    }
}
