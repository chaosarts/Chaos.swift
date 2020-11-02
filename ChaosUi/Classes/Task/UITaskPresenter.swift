//
//  UITaskPresenter.swift
//  ChaosUi
//
//  Created by Fu Lam Diep on 26.10.20.
//

import Foundation
import ChaosCore

open class UITaskPresenter: TaskRunnerSource, TaskRunnerDelegate {

    /// Provides the list of tasks to execute by the task runner.
    private var tasks: [UITaskViewModel] = []

    /// Provides the view controller to use for displaying updates.
    public weak var taskViewController: UITaskViewController?


    // MARK: Initialization

    /// Initializes the presenter with the given task view controller
    public init (taskViewController: UITaskViewController? = nil) {
        self.taskViewController = taskViewController
    }


    // MARK: Task Management

    /// Inserts a new task at given index.
    public func insert (task: Task, atIndex index: Int, title: String? = nil,
                        detailText: String? = nil, image: UIImage? = nil) -> Self {
        let taskViewModel = UITaskViewModel(task: task, title: title,
                                            detailText: detailText, image: image)
        tasks.insert(taskViewModel, at: index)
        return self
    }

    /// Appends a task to the presenter to run.
    @discardableResult
    public func add (task: Task, title: String? = nil, detailText: String? = nil,
                     image: UIImage? = nil) -> Self {
        return self.insert(task: task, atIndex: tasks.count, title: title,
                    detailText: detailText, image: image)
    }

    /// Determines whether the task with given identifier exists or not.
    public func contains (taskWithIdentifier id: String) -> Bool {
        tasks.contains(where: { $0.id == id })
    }

    /// Removes and returns the task with given id
    public func remove (taskWithIdentfier id: String) -> Task? {
        guard let index = tasks.firstIndex(where: { $0.id == id }) else { return nil }
        return tasks.remove(at: index).task
    }

    /// Sets the title for the task at given index.
    public func set (title: String?, forTaskAtIndex index: Int) -> Self {
        let taskViewModel = self.taskViewModel(atIndex: index)
        taskViewModel.title = title
        return self
    }

    /// Sets the detail text for the task at given index.
    public func set (detailText: String?, forTaskAtIndex index: Int) -> Self {
        let taskViewModel = self.taskViewModel(atIndex: index)
        taskViewModel.detailText = detailText
        return self
    }

    /// Sets the image for the task at given index.
    public func set (image: UIImage?, forTaskAtIndex index: Int) -> Self {
        let taskViewModel = self.taskViewModel(atIndex: index)
        taskViewModel.image = image
        return self
    }

    /// Retrieves the task view model that corresponds to the task at given index.
    private func taskViewModel (atIndex index: Int) -> UITaskViewModel {
        tasks[index]
    }


    // MARK: TaskRunnerSource Implementation

    public func numberOfTasks(_ taskRunner: TaskRunner) -> Int {
        tasks.count
    }

    public func taskRunner(_ taskRunner: TaskRunner, taskAtIndex index: Int) -> Task {
        tasks[index].task
    }


    // MARK: TaskRunnerDelegate Implementation

    public func taskRunner(_ taskRunner: TaskRunner, willRunTaskAtIndex index: Int) {
        let viewModel = tasks[Int(index)]
        taskViewController?.progress = Float(index) / Float(tasks.count)
        taskViewController?.present(task: viewModel)
    }


    public func taskRunner(_ taskRunner: TaskRunner, didFinishWithError error: Error?) {
        if let error = error {
            taskViewController?.present(error: error)
        }
    }
}
