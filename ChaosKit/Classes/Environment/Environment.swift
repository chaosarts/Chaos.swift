//
//  Environment.swift
//  Pods
//
//  Created by Fu Lam Diep on 19.10.20.
//

import Foundation

public protocol Environment: class, Codable {

    /// Provides the string that identifies this environment
    var identifier: String { get }

    /// Provides a title for this environment for display.
    var title: String? { get }

    /// Provides an optional description for this environment to display.
    var description: String? { get }


    // MARK: Methods

    /// Returns the number of tasks to execute to setup this environment.
    func numberOfEnvironmentSetupTasks () -> Int

    /// Returns the setup task at given index.
    func environmentSetupTask (at index: Int) -> EnvironmentSetupTask

    /// Returns the configuration at given path.
    func configuration<Config> (at path: [String]) -> Config?
}
