//
//  Polynom.swift
//  ChaosMath
//
//  Created by Fu Lam Diep on 14.04.21.
//

public struct Polynom<Coefficient: FloatingPoint> {

    private var monomsByPower: [Int: Coefficient]

    public subscript(_ power: Int) -> Coefficient {
        get { monomsByPower[power] ?? 0 }
        set { monomsByPower[power] = newValue == 0 ? nil : newValue }
    }

    public init(monomsByPower: [Int: Coefficient] = [:]) {
        self.monomsByPower = monomsByPower
    }

    public func map(_ work: (Int, Coefficient) throws -> Coefficient?) rethrows -> Self {
        var monomsByPower: [Int: Coefficient] = [:]
        try self.monomsByPower.forEach { power, coefficient in
            monomsByPower[power] = try work(power, coefficient)
        }
        return Polynom(monomsByPower: monomsByPower)
    }

    public static func +(lhs: Self, rhs: Self) -> Self {
        var result = lhs.monomsByPower
        rhs.monomsByPower.forEach { power, rhsCoefficient in
            let coefficient = (result[power] ?? 0) + rhsCoefficient
            if coefficient == 0 {
                result[power] = nil
            } else {
                result[power] = coefficient
            }
        }
        return Polynom(monomsByPower: result)
    }

    public static prefix func -(polynom: Self) -> Self {
        Polynom(monomsByPower: polynom.monomsByPower.mapValues { -$0 })
    }

    public static func -(lhs: Self, rhs: Self) -> Self {
        lhs + (-rhs)
    }
}
