//
//  ChaosMath.swift
//  ChaosMath
//
//  Created by Fu Lam Diep on 14.04.21.
//

import Foundation

// MARK: - Dimension 4

public func *<Component: SignedNumeric> (_ lhs: t_point4<Component>, _ rhs: t_mat4<Component>) -> t_point4<Component> {
    var x = lhs.components[0] * rhs.components[0]
    x += lhs.components[1] * rhs.components[4]
    x += lhs.components[2] * rhs.components[8]
    x += lhs.components[3] * rhs.components[12]

    var y = lhs.components[0] * rhs.components[1]
    y += lhs.components[1] * rhs.components[5]
    y += lhs.components[2] * rhs.components[9]
    y += lhs.components[3] * rhs.components[13]

    var z = lhs.components[0] * rhs.components[2]
    z += lhs.components[1] * rhs.components[6]
    z += lhs.components[2] * rhs.components[10]
    z += lhs.components[3] * rhs.components[14]

    var w = lhs.components[0] * rhs.components[3]
    w += lhs.components[1] * rhs.components[7]
    w += lhs.components[2] * rhs.components[11]
    w += lhs.components[3] * rhs.components[15]

    return t_point4(x, y, z, w)
}

public func *<Component: SignedNumeric> (_ lhs: t_mat4<Component>, _ rhs: t_point4<Component>) -> t_point4<Component> {
    var x = rhs.components[0] * lhs.components[0]
    x += rhs.components[1] * lhs.components[1]
    x += rhs.components[2] * lhs.components[2]
    x += rhs.components[3] * lhs.components[3]

    var y = rhs.components[0] * lhs.components[4]
    y += rhs.components[1] * lhs.components[5]
    y += rhs.components[2] * lhs.components[6]
    y += rhs.components[3] * lhs.components[7]

    var z = rhs.components[0] * lhs.components[8]
    z += rhs.components[1] * lhs.components[9]
    z += rhs.components[2] * lhs.components[10]
    z += rhs.components[3] * lhs.components[11]

    var w = rhs.components[0] * lhs.components[12]
    w += rhs.components[1] * lhs.components[13]
    w += rhs.components[2] * lhs.components[14]
    w += rhs.components[3] * lhs.components[15]

    return t_point4(x, y, z, w)
}

public func *<Component: SignedNumeric> (_ lhs: t_vec4<Component>, _ rhs: t_mat4<Component>) -> t_vec4<Component> {
    var x = lhs.components[0] * rhs.components[0]
    x += lhs.components[1] * rhs.components[4]
    x += lhs.components[2] * rhs.components[8]
    x += lhs.components[3] * rhs.components[12]

    var y = lhs.components[0] * rhs.components[1]
    y += lhs.components[1] * rhs.components[5]
    y += lhs.components[2] * rhs.components[9]
    y += lhs.components[3] * rhs.components[13]

    var z = lhs.components[0] * rhs.components[2]
    z += lhs.components[1] * rhs.components[6]
    z += lhs.components[2] * rhs.components[10]
    z += lhs.components[3] * rhs.components[14]

    var w = lhs.components[0] * rhs.components[3]
    w += lhs.components[1] * rhs.components[7]
    w += lhs.components[2] * rhs.components[11]
    w += lhs.components[3] * rhs.components[15]

    return t_vec4(components: [x, y, z, w])
}

public func *<Component: SignedNumeric> (_ lhs: t_mat4<Component>, _ rhs: t_vec4<Component>) -> t_vec4<Component> {
    var x = rhs.components[0] * lhs.components[0]
    x += rhs.components[1] * lhs.components[1]
    x += rhs.components[2] * lhs.components[2]
    x += rhs.components[3] * lhs.components[3]

    var y = rhs.components[0] * lhs.components[4]
    y += rhs.components[1] * lhs.components[5]
    y += rhs.components[2] * lhs.components[6]
    y += rhs.components[3] * lhs.components[7]

    var z = rhs.components[0] * lhs.components[8]
    z += rhs.components[1] * lhs.components[9]
    z += rhs.components[2] * lhs.components[10]
    z += rhs.components[3] * lhs.components[11]

    var w = rhs.components[0] * lhs.components[12]
    w += rhs.components[1] * lhs.components[13]
    w += rhs.components[2] * lhs.components[14]
    w += rhs.components[3] * lhs.components[15]

    return t_vec4(components: [x, y, z, w])
}

public func +<Component: SignedNumeric> (_ lhs: t_point4<Component>, _ rhs: t_vec4<Component>) -> t_point4<Component> {
    t_point4(components: [
        lhs.components[0] + rhs.components[0],
        lhs.components[1] + rhs.components[1],
        lhs.components[2] + rhs.components[2],
        lhs.components[3] + rhs.components[3]
    ])
}

public func -<Component: SignedNumeric> (_ lhs: t_point4<Component>, _ rhs: t_vec4<Component>) -> t_point4<Component> {
    lhs + -rhs
}


// MARK: - Dimension 3

public func *<Component: SignedNumeric> (_ lhs: t_point3<Component>, _ rhs: t_mat4<Component>) -> t_point3<Component> {
    var x = lhs.components[0] * rhs.components[0]
    x += lhs.components[1] * rhs.components[3]
    x += lhs.components[2] * rhs.components[6]

    var y = lhs.components[0] * rhs.components[1]
    y += lhs.components[1] * rhs.components[4]
    y += lhs.components[2] * rhs.components[7]

    var z = lhs.components[0] * rhs.components[2]
    z += lhs.components[1] * rhs.components[5]
    z += lhs.components[2] * rhs.components[8]

    return t_point3(x, y, z)
}

public func *<Component: SignedNumeric> (_ lhs: t_mat3<Component>, _ rhs: t_point3<Component>) -> t_point3<Component> {
    var x = rhs.components[0] * lhs.components[0]
    x += rhs.components[1] * lhs.components[1]
    x += rhs.components[2] * lhs.components[2]

    var y = rhs.components[0] * lhs.components[3]
    y += rhs.components[1] * lhs.components[4]
    y += rhs.components[2] * lhs.components[5]

    var z = rhs.components[0] * lhs.components[6]
    z += rhs.components[1] * lhs.components[7]
    z += rhs.components[2] * lhs.components[8]

    return t_point3(x, y, z)
}

public func *<Component: SignedNumeric> (_ lhs: t_vec3<Component>, _ rhs: t_mat4<Component>) -> t_vec3<Component> {
    var x = lhs.components[0] * rhs.components[0]
    x += lhs.components[1] * rhs.components[3]
    x += lhs.components[2] * rhs.components[6]

    var y = lhs.components[0] * rhs.components[1]
    y += lhs.components[1] * rhs.components[4]
    y += lhs.components[2] * rhs.components[7]

    var z = lhs.components[0] * rhs.components[2]
    z += lhs.components[1] * rhs.components[5]
    z += lhs.components[2] * rhs.components[8]

    return t_vec3(x, y, z)
}

public func *<Component: SignedNumeric> (_ lhs: t_mat3<Component>, _ rhs: t_vec3<Component>) -> t_vec3<Component> {
    var x = rhs.components[0] * lhs.components[0]
    x += rhs.components[1] * lhs.components[1]
    x += rhs.components[2] * lhs.components[2]

    var y = rhs.components[0] * lhs.components[3]
    y += rhs.components[1] * lhs.components[4]
    y += rhs.components[2] * lhs.components[5]

    var z = rhs.components[0] * lhs.components[6]
    z += rhs.components[1] * lhs.components[7]
    z += rhs.components[2] * lhs.components[8]

    return t_vec3(x, y, z)
}

public func +<Component: SignedNumeric> (_ lhs: t_point3<Component>, _ rhs: t_vec3<Component>) -> t_point3<Component> {
    t_point3(components: [
        lhs.components[0] + rhs.components[0],
        lhs.components[1] + rhs.components[1],
        lhs.components[2] + rhs.components[2]
    ])
}

public func -<Component: SignedNumeric> (_ lhs: t_point3<Component>, _ rhs: t_vec3<Component>) -> t_point3<Component> {
    lhs + -rhs
}

public func -<Component: SignedNumeric> (_ lhs: t_point3<Component>, _ rhs: t_point3<Component>) -> t_vec3<Component> {
    t_vec3(
        lhs.components[0] - rhs.components[0],
        lhs.components[1] - rhs.components[1],
        lhs.components[2] - rhs.components[2]
    )
}

// MARK: - Dimension 2

public func *<Component: SignedNumeric> (_ lhs: t_point2<Component>, _ rhs: t_mat4<Component>) -> t_point2<Component> {
    var x = lhs.components[0] * rhs.components[0]
    x += lhs.components[1] * rhs.components[2]

    var y = lhs.components[0] * rhs.components[1]
    y += lhs.components[1] * rhs.components[3]

    return t_point2(x, y)
}

public func *<Component: SignedNumeric> (_ lhs: t_mat3<Component>, _ rhs: t_point2<Component>) -> t_point2<Component> {
    var x = rhs.components[0] * lhs.components[0]
    x += rhs.components[1] * lhs.components[1]

    var y = rhs.components[0] * lhs.components[2]
    y += rhs.components[1] * lhs.components[3]

    return t_point2(x, y)
}

public func +<Component: SignedNumeric> (_ lhs: t_point2<Component>, _ rhs: t_vec2<Component>) -> t_point2<Component> {
    t_point2(components: [
        lhs.components[0] + rhs.components[0],
        lhs.components[1] + rhs.components[1]
    ])
}

public func -<Component: SignedNumeric> (_ lhs: t_point2<Component>, _ rhs: t_vec2<Component>) -> t_point2<Component> {
    lhs + -rhs
}

public func -<Component: SignedNumeric> (_ lhs: t_point2<Component>, _ rhs: t_point2<Component>) -> t_vec2<Component> {
    t_vec2(
        lhs.components[0] - rhs.components[0],
        lhs.components[1] - rhs.components[1]
    )
}
