//
//  MeshDelegate.swift
//  ChaosThree
//
//  Created by Fu Lam Diep on 12.09.21.
//

import Foundation

public protocol MeshDelegate: AnyObject {
    func mesh(_ mesh: Mesh, willReloadVerticesWithPrimitiveType primitiveType: Mesh.PrimitiveType)
    func mesh(_ mesh: Mesh, didReloadVerticesWithPrimitiveType primitiveType: Mesh.PrimitiveType)
    func mesh(_ mesh: Mesh, willReloadVerticesAt indices: [Int], withPrimitiveType primitiveType: Mesh.PrimitiveType)
    func mesh(_ mesh: Mesh, didReloadVerticesAt indices: [Int], withPrimitiveType primitiveType: Mesh.PrimitiveType)
}

public extension MeshDelegate {
    func mesh(_ mesh: Mesh, willReloadVerticesWithPrimitiveType primitiveType: Mesh.PrimitiveType) {}
    func mesh(_ mesh: Mesh, didReloadVerticesWithPrimitiveType primitiveType: Mesh.PrimitiveType) {}
    func mesh(_ mesh: Mesh, willReloadVerticesAt indices: [Int], withPrimitiveType primitiveType: Mesh.PrimitiveType) {}
    func mesh(_ mesh: Mesh, didReloadVerticesAt indices: [Int], withPrimitiveType primitiveType: Mesh.PrimitiveType) {}
}
