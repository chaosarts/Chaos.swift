//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 15.02.22.
//

import Foundation
import ChaosMath

public protocol SceneLight {
    var color: Color { get }

    var intensity: Float { get }
}

public protocol DirectionalLight: SceneLight {
    var direction: Vec3 { get }
}

public protocol PointLight: SceneLight {
    var position: Point3 { get }
}
