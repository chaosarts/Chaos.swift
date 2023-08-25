//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 15.02.22.
//

import Foundation
import ChaosMath

open class SceneModel {

    // MARK: - Hierarchy Properties

    public internal(set) weak var scene: Scene?

    public internal(set) weak var parent: SceneModel?

    public var indexInParent: Int? {
        parent?.index(of: self)
    }

    public internal(set) var children: [SceneModel] = []


    // MARK: Properties

    public let mesh: Mesh = Mesh()

    public weak var meshDelegate: MeshDelegate? {
        get { mesh.delegate }
        set { mesh.delegate = newValue }
    }

    public var scale: Vec3 = Vec3(1, 1, 1)

    public var position: Vec3 = .zero {
        didSet { setNeedsUpdate() }
    }

    public var rotationAxis: Vec3 = Vec3(0, 0, 1) {
        didSet { setNeedsUpdate() }
    }

    public var rotationAngle: Vec3.Component = 0 {
        didSet { setNeedsUpdate() }
    }

    public var rotation: Quaternion {
        let halfAngle = rotationAngle / 2
        return Quaternion(real: cos(halfAngle), imaginary: sin(halfAngle) * rotationAxis)
    }

    public var rotationMatrix: Mat4 {
        rotation.rotationMatrix
    }

    public var isHidden: Bool = false  {
        didSet { setNeedsUpdate() }
    }

    public var transformation: Mat4 {
        Mat4(components: [
            scale.x, 0, 0, position.x,
            0, scale.y, 0, position.y,
            0, 0, scale.z, position.z,
            0, 0, 0, 1
        ]) * rotationMatrix
    }


    // MARK: Lifecycle Properties

    private var needsUpdate: Bool = true


    // MARK: - Initialization

    public init() {
        mesh.dataSource = self
        mesh.delegate = self
    }


    // MARK: - Hierarchy Management

    public func index(of child: SceneModel) -> Int? {
        children.firstIndex { $0 === child }
    }

    public func insert(child: SceneModel, at index: Int) {
        if child.parent != nil {
            child.removeFromParent()
        }

        child.willMove(toParent: self)
        children.insert(child, at: index)
        child.parent = self
        child.didMoveToParent()
    }

    public func append(_ child: SceneModel) {
        insert(child: child, at: children.count)
    }

    public func append<S: Sequence>(contentsOf children: S) where S.Element == SceneModel {
        children.forEach { self.append($0) }
    }

    public func removeFromParent () {
        guard let parent = parent, let index = indexInParent else { return }
        willUnsetParent()
        parent.children.remove(at: index)
        self.parent = nil
        didUnset(parent: parent)
    }


    // MARK: Hierarchy Events

    open func willUnsetParent() {

    }

    open func didUnset(parent: SceneModel) {

    }

    open func willMove(toParent parent: SceneModel) {

    }

    open func didMoveToParent() {

    }

    open func willExitScene() {

    }

    open func didExit(scene: Scene) {

    }

    open func willEnter(scene: Scene) {

    }

    open func didEnterScene() {

    }


    // MARK: - Lifecycle

    public func setNeedsUpdate() {
        needsUpdate = true
    }
}

extension SceneModel: MeshDataSource {
    public func mesh(_ mesh: Mesh, triangleAt index: Int) -> Mesh.TriangleRef {
        (0, 0, 0)
    }

    public func mesh(_ mesh: Mesh, vertexAt index: Int) -> Point3 {
        .zero
    }

    public func numberOfVertices(_ mesh: Mesh) -> Int {
        0
    }

    public func numberOfTriangles(_ mesh: Mesh) -> Int {
        0
    }
}

extension SceneModel: MeshDelegate {
    public func mesh(_ mesh: Mesh, didMoveVertexAt index: Int) {

    }
}
