//
//  main.swift
//  ChaosCliExample
//
//  Created by Fu Lam Diep on 29.10.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import Chaos

@objc protocol A {}

@objc protocol B {}

protocol F {}

@objc class C: NSObject, A, B, F{}

public class DependencyManager {

    private var classes: [NSObject.Type] = []

    public func register (_ type: NSObject.Type) {
        classes.append(type)
    }

    public func resolve (_ proto: Protocol) -> NSObject? {
        classes.first(where: { $0.conforms(to: proto) })?.init()
    }
}


func main () {
    let manager = DependencyManager()
    manager.register(C.self)
    if let a = manager.resolve(A.self) {
        print(type(of: a))
    } else {
        print("Implementation of A not found")
    }

    if let b = manager.resolve(B.self) {
        print(type(of: b))
    } else {
        print("Implementation of B not found")
    }

    var count: UInt32 = 0
    guard let protocols = class_copyProtocolList(C.self, &count) else {
        print("Unable to get protocol list")
        return
    }

    print("Protocols counted: \(count)")
    for i in 0..<Int(count) {
        print(type(of: protocols[i]))
    }

    guard let classes = objc_copyClassList(&count) else {
        print("Unable to get list of classes")
        return
    }

    let classList = UnsafePointer(classes)

    print("Classes counted: \(count)")
//    for i in 0..<Int(count) {
//        print(classList.advanced(by: i).pointee)
//    }
}

main()
