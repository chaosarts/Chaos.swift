//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 19.02.22.
//

import Foundation
import ChaosMath

public struct t_color<Component: CodableSignedNumeric & Comparable>: Codable {

    public private(set) var components: [Component]

    public var red: Component {
        get { components[0] }
        set { components[0] = min(1, max(0, newValue)) }
    }

    public var blue: Component {
        get { components[1] }
        set { components[1] = min(1, max(0, newValue)) }
    }

    public var green: Component {
        get { components[2] }
        set { components[2] = min(1, max(0, newValue)) }
    }

    public var vector: t_vec3<Component> {
        t_vec3(red, green, blue)
    }

    public init(red: Component = .zero, green: Component = .zero, blue: Component = .zero) {
        components = [
            min(1, max(0, red)),
            min(1, max(0, green)),
            min(1, max(0, blue))
        ]
    }

    public static func +(lhs: Self, rhs: Self) -> Self {
        t_color(red: lhs.red + rhs.red,
                green: lhs.green + rhs.green,
                blue: lhs.blue + rhs.blue)
    }

    public static func -(lhs: Self, rhs: Self) -> Self {
        t_color(red: lhs.red - rhs.red,
                green: lhs.green - rhs.green,
                blue: lhs.blue - rhs.blue)
    }

    public static func *(lhs: Self, rhs: Self) -> Self {
        t_color(red: lhs.red * rhs.red,
                green: lhs.green * rhs.green,
                blue: lhs.blue * rhs.blue)
    }
}

public extension t_color {
    static var black: Self { t_color(red: 0, green: 0, blue: 0) }

    static var white: Self { t_color(red: 1, green: 1, blue: 1) }

    static var red: Self { t_color(red: 1) }

    static var green: Self { t_color(green: 1) }

    static var blue: Self { t_color(blue: 1) }

    static var yellow: Self { t_color(red: 1, green: 1) }

    static var magenta: Self { t_color(red: 1, blue: 1) }

    static var cyan: Self { t_color(green: 1, blue: 1) }
}

public typealias Colorf = t_color<Float>
public typealias Color = Colorf
