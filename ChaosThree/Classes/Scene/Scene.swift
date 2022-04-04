//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 15.02.22.
//

import Foundation

public class Scene {

    public private(set) var rootObject: SceneModel!

    public init(rootObject: SceneModel? = nil) {
        self.rootObject = rootObject
    }
}
