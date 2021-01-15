//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 14.01.21.
//

import Foundation

public func class_conformsToProtocol (_ cls: AnyClass?, _ proto: Protocol) -> Bool {
    let conforms = Foundation.class_conformsToProtocol(cls, proto)
    guard let cls = cls else { return conforms }
    return conforms || ChaosCore.class_conformsToProtocol(class_getSuperclass(cls), proto)
}

public func class_getInjectables () -> [Resolvable.Type] {
    ChaosCore.class_getClassList().compactMap({
        guard ChaosCore.class_conformsToProtocol($0, Resolvable.self) else { return nil }
        return $0 as? Resolvable.Type
    })
}

public func class_getClassList () -> [AnyClass] {
    var count: UInt32 = 0

    guard let tmpPointer = objc_copyClassList(&count) else {
        return []
    }

    let pointer = UnsafeMutablePointer(mutating: tmpPointer)
    let classList = (0..<Int(count)).map({ pointer[$0] })
    free(pointer)
    return classList
}
