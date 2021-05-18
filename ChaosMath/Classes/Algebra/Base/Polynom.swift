//
//  Polynom.swift
//  ChaosMath
//
//  Created by Fu Lam Diep on 14.04.21.
//

import Foundation

@dynamicCallable
public struct Monom<C: FloatingPoint> {

    public let coefficient: C

    public let power: Int

    public init (coefficient: C, power: Int) {
        self.coefficient = coefficient
        self.power = power
    }

    func dynamicallyCall (withArguments args: [C]) -> C {
        guard args.count == 1 else {
            fatalError("Dynamic callable Monom requires exactly one argument.")
        }

        guard power > 0 else {
            return 0
        }

        let x = args[0]
        var result: C = x
        for _ in 1..<power {
            result = result * x
        }

        return coefficient * result
    }

    static func + (_ lhs: Monom<C>, _ rhs: Monom<C>) -> Monom<C> {
        guard lhs.power == rhs.power else {
            fatalError("Unable to calculate sum of monoms of different power")
        }
        return Monom(coefficient: lhs.coefficient + rhs.coefficient, power: lhs.power)
    }

    static prefix func - (_ monom: Monom<C>) -> Monom<C> {
        return Monom(coefficient: -monom.coefficient, power: monom.power)
    }

    static func - (_ lhs: Monom<C>, _ rhs: Monom<C>) -> Monom<C> {
        lhs + -rhs
    }

    static func * (_ lhs: Monom<C>, _ rhs: Monom<C>) -> Monom<C> {
        Monom(coefficient: lhs.coefficient * rhs.coefficient, power: lhs.power + rhs.power)
    }
}

@dynamicCallable
public struct Polynom<C: FloatingPoint> {

    private let monomsByPower: [Int: Monom<C>] = [:]

    public var monoms: [Monom<C>] {
        monomsByPower.values.map({ $0 }).sorted(by: { $0.power < $1.power })
    }

    func dynamicallyCall (withArguments args: [C]) -> C {
        guard args.count == 1 else {
            fatalError("Dynamic callable Monom requires exactly one argument.")
        }

        let x = args[0]
        return monoms.reduce(0, { $0 + $1(x) })
    }

    public init (_ monoms: [Monom<C>]) {
        var dictionary: [Int: Monom<C>] = [:]
        for monom in monoms {
            if monom.coefficient == 0 {
                continue
            }
            if let m = dictionary[monom.power] {
                dictionary[monom.power] = m + monom
            } else {
                dictionary[monom.power] = monom
            }
        }
    }

    public static func + (_ lhs: Polynom, rhs: Polynom) -> Polynom {
        Polynom(lhs.monoms + rhs.monoms)
    }

    public static prefix func - (_ polynom: Polynom) -> Polynom {
        Polynom(polynom.monoms.map({ -$0 }))
    }

    public static func - (_ lhs: Polynom, _ rhs: Polynom) -> Polynom {
        lhs + -rhs
    }

    public static func * (_ lhs: Polynom, _ rhs: Polynom) -> Polynom {
        let lhsMonoms = lhs.monoms
        let rhsMonoms = rhs.monoms

        var result: [Monom<C>] = []
        for l in lhsMonoms {
            for r in rhsMonoms {
                result.append(l * r)
            }
        }
        return Polynom(result)
    }
}
