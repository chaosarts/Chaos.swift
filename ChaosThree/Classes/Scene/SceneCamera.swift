//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 15.02.22.
//

import Foundation
import ChaosMath

public class SceneCamera: SceneObject {

    // MARK: - Properties

    public var direction: Vec3 {
        let vector = rotation.matrix * Vec4(0, 0, 1)
        return Vec3(vector.x, vector.y, vector.z)
    }

    public var projectionType: ProjectionType

    public var viewingVolume: ViewingVolume

    public var projectionMatrix: Mat4 {
        switch projectionType {
        case .orthographic:
            return viewingVolume.orthographicMatrix
        case .perspective:
            return viewingVolume.perspectiveMatrix
        }
    }

    // MARK: - Initialization

    public init(position: Point3 = .zero,
                rotation: Rot3 = .zero,
                projectionType: ProjectionType = .perspective,
                viewingVolume: ViewingVolume = ViewingVolume()) {
        self.projectionType = projectionType
        self.viewingVolume = viewingVolume
        super.init(position: position, rotation: rotation)
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.projectionType = try container.decode(ProjectionType.self, forKey: "projectionType")
        self.viewingVolume = try container.decode(ViewingVolume.self, forKey: "viewingVolume")
        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(projectionType, forKey: "projectionType")
        try container.encode(viewingVolume, forKey: "viewingVolume")
        try super.encode(to: encoder)
    }

    public func point(to target: Point3) {
        let direction = direction
        let vector = Vec3(from: position, to: target)
        let normal = direction.cross(vector).unified
        rotation.axis = angle(normal, rotation.axis) > (.pi / 2) ? -normal : normal
        rotation.angle = angle(direction, vector)
    }
}

public extension SceneCamera {

    enum ProjectionType: Int, Codable {
        case orthographic
        case perspective
    }

    struct ViewingVolume: Codable {

        public var left: Float

        public var right: Float

        public var top: Float

        public var bottom: Float

        public var near: Float

        public var far: Float

        public var center: Point2 {
            get { Point2(left + width / 2, top + height / 2) }
            set {
                let width = width / 2
                let height = height / 2
                left = newValue.x - width
                right = newValue.x + width
                top = newValue.y + height
                bottom = newValue.y - height
            }
        }

        public var width: Float {
            get { right - left }
            set {
                let center = center
                let width = newValue / 2
                left = center.x - width
                right = center.x + width
            }
        }

        public var height: Float {
            get { top - bottom }
            set {
                let center = center
                let height = newValue / 2
                top = center.y + height
                bottom = center.y - height
            }
        }

        public var depth: Float { far - near }

        public var aspect: Float { width / height }

        public var fovy: Float { 2 * deg(atan2(top, near)); }

        public var perspectiveMatrix: Mat4 {
            let near = near
            let far = far
            let left = left
            let right = right
            let top = top
            let bottom = bottom
            let width = width
            let height = height
            let depth = -depth

            var mat = Mat4.zero
            mat[0, 0] = 2 * near / width
            mat[0, 2] = (right + left) / width
            mat[1, 1] = 2 * near / height
            mat[1, 2] = (top + bottom) / height
            mat[2, 2] = (far + near) / depth
            mat[3, 2] = 2 * near * far / depth
            mat[3, 2] = -1
            return mat
        }

        public var orthographicMatrix: Mat4 {
            let near = near
            let far = far
            let left = left
            let right = right
            let top = top
            let bottom = bottom
            let width = width
            let height = height
            let depth = depth

            var mat = Mat4.zero
            mat[0, 0] = 2 / width
            mat[0, 3] = -(right + left) / width
            mat[1, 1] = 2 / height
            mat[1, 3] = -(top + bottom) / height
            mat[2, 2] = -2 / depth
            mat[2, 3] = -(far + near) / depth
            mat[3, 3] = 1
            return mat
        }

        public init(left: Float = -0.5,
                    right: Float = 0.5,
                    top: Float = 0.5,
                    bottom: Float = -0.5,
                    near: Float = 1.0,
                    far: Float = 10) {
            self.left = left
            self.right = right
            self.top = top
            self.bottom = bottom
            self.near = near
            self.far = far
        }
    }
}
