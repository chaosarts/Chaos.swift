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
@objc public protocol TaskRunnerDelegate: class {

    /// Tells the delegate, that the task runner will start executing the task
    /// from the task source.
    @objc optional func taskRunnerWillStart (_ taskRunner: TaskRunner)

    /// Tells the delegate that the task runner has resumed on executing tasks.
    @objc optional func taskRunnerWillResume (_ taskRunner: TaskRunner)

    /// Tells the delegate, that the task runner is about to run the task at given
    /// index.
    @objc optional func taskRunner (_ taskRunner: TaskRunner, willRunTaskAt index: Int)

    /// Tells the delegate, that the task runner has finished executing task at
    /// given index successfully.
    @objc optional func taskRunner (_ taskRunner: TaskRunner, didFinishTaskAt index: Int)

    /// Tellse the delegate that the task at given index has failed with given
    /// error. At this point the runner also stops running.
    @objc optional func taskRunner (_ taskRunner: TaskRunner, taskAt index: Int, didFailWithError error: Error)

    /// Tells the delegate, that the taskrunner has finished the tasks
    /// successfully.
    @objc optional func taskRunnerDidFinish (_ taskRunner: TaskRunner)
}
