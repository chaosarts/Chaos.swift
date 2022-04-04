//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 19.02.22.
//

import Foundation
import ChaosMath

open class SceneObject: Codable {

    public var position: Point3

    public var positionMatrix: Mat4 {
        Mat4(a11: 0, a12: 0, a13: 0, a14: position.x,
             a21: 0, a22: 0, a23: 0, a24: position.y,
             a31: 0, a32: 0, a33: 0, a34: position.z,
             a41: 0, a42: 0, a43: 0, a44: 1)
    }

    public var rotation: Rot3

    public init(position: Point3 = .zero, rotation: Rot3 = .zero) {
        self.position = position
        self.rotation = rotation
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.position = try container.decode(Point3.self, forKey: "position")
        self.rotation = try container.decode(Rot3.self, forKey: "rotation")
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(position, forKey: "position")
        try container.encode(rotation, forKey: "rotation")
    }
}
