//
//  Box3.swift
//  ChaosMath
//
//  Created by Fu Lam Diep on 10.09.21.
//

import Foundation

public struct t_box3<Component: SignedNumeric> {

    public var min
}

public typealias Box3i = t_box3<Int>
public typealias Box3f = t_box3<Float>
public typealias Box3d = t_box3<Double>
public typealias Box3 = Box3f
