//
//  EnvironmentSetupTask.swift
//  ChaosKit
//
//  Created by Fu Lam Diep on 19.10.20.
//

import ChaosCore

public protocol EnvironmentSetupTask {

    var environment: Environment { get }

    var title: String { get }
    var description: String? { get }

    func run () -> Promise<Void>
}
