//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 15.02.22.
//

import Foundation

public protocol MeshDelegate: AnyObject {

    func mesh(_ mesh: Mesh, didMoveVertexAt index: Int)
}
