//
//  TaskRunner.swift
//  ChaosCore
//
//  Created by Fu Lam Diep on 22.10.20.
//

import Foundation

public class TaskRunner: NSObject {

    // MARK: Managing Tasks

    /// Provides the object that serves as source of tasks for the task runner.
    public weak var taskSource: TaskRunnerSource?

    /// Provides the list of tasks fetched from the task source.
    private var tasks: [Task] = []


    // MARK: Get the State of the Task Runner

    /// Provides the number of tasks fetched from the task source.
    public var numberOfTasks: Int { tasks.count }

    /// Indicates which task to execute next
    public private(set) var currentTaskIndex: Int = 0

    /// Indicates, that the runner is currently executing the tasks one by one.
    public private(set) var isRunning: Bool = false

    /// Provides the promise to resolve of the current task.
    private var promise: Promise<Void>?


    // MARK: Managing Task Runner Interaction

    /// Provides the object that serves as delegate.
    public weak var delegate: TaskRunnerDelegate?


    // MARK: Get Tasks

    public func task (at index: Int) -> Task {
        return tasks[index]
    }

    // MARK: Controlling Task Execution

    /// Invokes the task runner to run all tasks beginning at first index.
    @discardableResult
    public func start () -> Promise<Void> {
        reloadTasks()
        currentTaskIndex = 0
        delegate?.taskRunnerWillStart?(self)
        return run()
    }

    /// Reloads the array of tasks by fetching the tasks from the source.
    private func reloadTasks () {
        tasks = []
        guard let taskSource = taskSource else { return }
        let numberOfTasks = taskSource.numberOfTasks(self)
        for index in 0..<numberOfTasks {
            tasks.append(taskSource.taskRunner(self, taskAtIndex: index))
        }
    }

    /// Invokes the runner to continue executing the tasks at the index, where it
    /// failed last.
    @discardableResult
    public func resume () -> Promise<Void> {
        if promise == nil { return start() }
        delegate?.taskRunnerWillResume?(self)
        return run()
    }

    /// Invokes the task runner to run the tasks one by one. This will execute the
    /// code that `resume` and `start` have in common.
    private func run () -> Promise<Void> {
        guard let taskSource = taskSource else {
            let error = TaskRunnerError(code: .noTaskSource)
            return Promise(error: error)
        }

        if isRunning { cancel() }

        isRunning = true
        let promise: Promise<Void> = executeNextTask()
            .then({ self.delegate?.taskRunnerDidFinish?(self) })
            .always({ self.isRunning = false })

        self.promise = promise
        return promise
    }


    private func executeNextTask () -> Promise<Void> {
        guard currentTaskIndex < numberOfTasks else {
            return Promise()
        }

        let index = currentTaskIndex
        let task = tasks[index]
        
        delegate?.taskRunner?(self, willRunTaskAt: currentTaskIndex)

        return task.run()
            .recover({ error -> Void in
                guard let taskSource = self.taskSource,
                      taskSource.taskRunner(self, isTaskRequiredAtIndex: index) else {
                    throw error
                }
            })
            .catch({
                self.delegate?.taskRunner?(self, taskAt: index, didFailWithError: $0)
            })
            .then({ () -> Promise<Void> in
                self.currentTaskIndex = index + 1
                self.delegate?.taskRunner?(self, didFinishTaskAt: index)
                return self.executeNextTask()
            })
    }

    public func cancel () {
        promise?.cancel()
        promise = nil
        isRunning = false
    }
}
