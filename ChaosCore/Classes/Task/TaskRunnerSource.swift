//
//  TaskSource.swift
//  ChaosCore
//
//  Created by Fu Lam Diep on 22.10.20.
//

import Foundation

/// A protocol to describe the source of a task runner.
///
/// An implmentation of this protocol provides several informations for the task
/// runner to execute a set of task it provides.
public protocol TaskRunnerSource: class {

    /// Asks the source for the number of tasks to execute.
    func numberOfTasks (_ taskRunner: TaskRunner) -> Int

    /// Asks the source for the task to execute that corresponds to the given
    /// index.
    func taskRunner (_ taskRunner: TaskRunner, taskAtIndex index: Int) -> Task

    /// Asks the data source, whether the task at given index is required to
    /// finish successfully or not.
    func taskRunner (_ taskRunner: TaskRunner, isTaskRequiredAtIndex index: Int) -> Bool
}


public extension TaskRunnerSource {
    func taskRunner (_ taskRunner: TaskRunner, isTaskRequiredAtIndex index: Int) -> Bool { true }
}
