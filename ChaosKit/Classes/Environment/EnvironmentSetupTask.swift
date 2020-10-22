//
//  EnvironmentSetupTask.swift
//  ChaosKit
//
//  Created by Fu Lam Diep on 19.10.20.
//

import ChaosCore

public protocol EnvironmentSetupTask {

    /// Provides the title of the task. This can be used to display in a view.
    var title: String { get }

    /// Provides the detail description of the task.
    var detailText: String? { get }

    /// Executes the task
    func run (for environment: Environment) -> Promise<Void>
}
