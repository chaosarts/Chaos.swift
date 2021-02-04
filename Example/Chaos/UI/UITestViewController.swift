//
//  UITestViewController.swift
//  Chaos_Example
//
//  Created by Fu Lam Diep on 30.11.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import ChaosCore

public class A: Resolvable {
    public required init () {}
}

public class B: Resolvable {
    public required init () {}
}

public class UITestViewController: UIViewController {

    private var resolvableTypes: [Resolvable.Type] = [A.self, B.self]

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        for resolvableType in resolvableTypes {
            candidate(resolvableType)
        }
    }

    public func candidate (_ type: Resolvable.Type) {
        print(NSStringFromClass(type))
    }
}
