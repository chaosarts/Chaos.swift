//
//  TaskRunner.swift
//  ChaosCore
//
//  Created by Fu Lam Diep on 22.10.20.
//

import Foundation

public class TaskRunner: NSObject {

    public weak var taskSource: TaskRunnerSource!

    public weak var delegate: TaskRunnerDelegate?

    private var numberOfTasks: Int {
        taskSource?.numberOfTasks(self) ?? 0
    }

    private var currentTaskIndex: Int = 0

    private var promise: Promise<Void>?

    public func executeTasks (restart: Bool = false) -> Promise<Void> {
        promise?.cancel()

        guard let taskSource = taskSource else {
            let error = TaskRunnerError(code: .noTaskSource)
            return Promise(error: error)
        }

        if restart { currentTaskIndex = 0 }

        promise = executeNextTask()
            .then({ self.delegate?.taskRunner(self, didFinishWithError: nil) })

        return promise!
    }

    private func executeNextTask () -> Promise<Void> {
        guard currentTaskIndex < numberOfTasks else { return Promise() }

        let index = currentTaskIndex
        let task = self.taskSource.taskRunner(self, taskAtIndex: currentTaskIndex)
        
        delegate?.taskRunner(self, willRunTaskAtIndex: currentTaskIndex)

        return task.run()
            .recover(rescue)
            .recover(checkRequirement)
            .catch({
                self.delegate?.taskRunner(self, didStopRunningAtIndex: index, withError: $0)
            })
            .then({ () -> Promise<Void> in
                self.currentTaskIndex = index + 1
                self.delegate?.taskRunner(self, didFinishTaskAtIndex: index, withError: nil)
                return self.executeNextTask()
            })
    }

    private func rescue (_ error: Error) -> Promise<Void> {
        let index = currentTaskIndex
        return Promise<Void> { fulfill, reject -> Void in
            self.delegate?.taskRunner(self, didFinishTaskAtIndex: index, withError: error)

            guard self.taskSource.taskRunner(self, canRescueTaskAtIndex: index, withError: error) else {
                return reject(error)
            }

            self.taskSource.taskRunner(self, rescueTaskAtIndex: index, completion: { error in
                if let error = error { return reject(error) }
                let void: Void
                fulfill(void)
            })
        }
    }

    private func checkRequirement (_ error: Error) throws {
        if taskSource.taskRunner(self, isTaskRequiredAtIndex: currentTaskIndex) {
            throw error
        }
    }
}
