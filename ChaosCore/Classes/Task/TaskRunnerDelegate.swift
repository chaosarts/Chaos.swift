//
//  TaskRunnerDelegate.swift
//  ChaosCore
//
//  Created by Fu Lam Diep on 22.10.20.
//

import Foundation

/// A protocol to describe a delegate for a task runner.
///
/// A task runner informs the delegate abount several events during processing the
/// list of tasks of a task runner source.
public protocol TaskRunnerDelegate: class {

    /// Tells the delegate, that the task runner is about to run the task at given
    /// index.
    func taskRunner (_ taskRunner: TaskRunner, willRunTaskAtIndex index: Int)

    /// Tells the delegate, that the task runner has finished executing task at
    /// given index.
    func taskRunner (_ taskRunner: TaskRunner, didFinishTaskAtIndex index: Int, withError error: Error?)

    /// Tells the delegate that the task runner did stop running with task at
    /// given index, due to an error.
    func taskRunner (_ taskRunner: TaskRunner, didStopRunningAtIndex index: Int, withError error: Error)

    /// Tells the delegate, that the task runner has completed the list of it task
    /// source successfully.
    func taskRunner (_ taskRunner: TaskRunner, didFinishWithError error: Error?)
}


public extension TaskRunnerDelegate {
    func taskRunner (_ taskRunner: TaskRunner, willRunTaskAtIndex index: Int) {}
    func taskRunner (_ taskRunner: TaskRunner, didFinishTaskAtIndex index: Int, withError error: Error?) {}
    func taskRunner (_ taskRunner: TaskRunner, didStopRunningAtIndex index: Int, withError error: Error) {}
    func taskRunner (_ taskRunner: TaskRunner, didFinishWithError error: Error?) {}
}
