//
//  UITestViewController.swift
//  Chaos_Example
//
//  Created by Fu Lam Diep on 30.11.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import Chaos

public protocol NonObjcProtocol {}

@objc public protocol Injectable: NSObjectProtocol {
    @objc optional static var profile: String { get }
}

@objc public class Api: NSObject, Injectable {
    public static var profile: String = "KVV"
}

public class UITestViewController: UIViewController {

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        let cls: AnyClass = Api.self
//        print((cls as! NSObject.Type).perform(Selector("profile"))!.takeRetainedValue())

        var count: UInt32 = 0
        guard let pointer = objc_copyClassList(&count) else {
            fatalError("Unabled to copy class list.")
        }

        let classes = UnsafePointer(pointer)
        var injectables: [NSObject.Type] = []
        for i in 0..<Int(count) {
            let cls: AnyClass = classes[i]
            guard class_conformsToProtocol(cls, Injectable.self) else { continue }

            let profileSelector = Selector("profile")
            if (cls as! NSObject.Type).responds(to: profileSelector) {
                let unmanagedObject = (cls as! NSObject.Type).perform(profileSelector)
                let profile: String = unmanagedObject!.takeRetainedValue() as! String
                if (profile != "KVV") { continue }
            }

            injectables.append(cls as! NSObject.Type)
        }

        let type = Api.self as! NSObject.Type
        print(type)
    }
}
