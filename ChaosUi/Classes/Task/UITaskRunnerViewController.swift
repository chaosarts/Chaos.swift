//
//  UITaskRunnerViewController.swift
//  ChaosUi
//
//  Created by Fu Lam Diep on 26.10.20.
//

import Foundation

open class UITaskRunnerViewController: UIViewController {

    // MARK: Managing task presentation

    /// Provides the object, that reacts to certain event so f the task runner
    /// view controller.
    public weak var delegate: UITaskRunnerViewControllerDelegate?


    // MARK: Presentation Properties

    /// Provides the title of the task to display.
    open var taskTitleText: String? {
        get { taskTitleLabel?.text }
        set { taskTitleLabel?.text = newValue }
    }

    /// Provides the task details to display.
    open var taskDetailText: String? {
        get { taskDetailLabel?.text }
        set { taskDetailLabel?.text = newValue }
    }

    /// Provides the image to display for the current task.
    open var taskImage: UIImage? {
        get { taskImageView?.image }
        set { taskImageView?.image = newValue }
    }

    /// Provides the progress of the task runner. Basically it shows the number
    /// of finished tasks in relation to the total number of tasks.
    open var progress: Float {
        get { progressView?.progress ?? 0.0 }
        set { progressView?.setProgress(newValue ?? 0, animated: true) }
    }

    /// Provides the task view model to display.
    public var taskViewModel: UITaskViewModel? {
        didSet { updateViews() }
    }


    // MARK: View Properties

    /// Provides the label that displays the task title.
    @IBOutlet private weak var taskTitleLabel: UILabel?

    /// Provides the label that displays the task detail.
    @IBOutlet private weak var taskDetailLabel: UILabel?

    /// Provides the image view to display the task image.
    @IBOutlet private weak var taskImageView: UIImageView?

    /// Provides the progress view to display the progress of the task runner.
    @IBOutlet private weak var progressView: UIProgressView?


    // MARK: Updating View

    /// Updates the views corresponding to the set task view model.
    private func updateViews () {
        taskTitleText = taskViewModel?.title
        taskDetailText = taskViewModel?.detailText
        taskImage = taskViewModel?.image
    }
}


// MARK: -

extension UITaskRunnerViewController: TaskRunnerDelegate {
    public func taskRunner(_ taskRunner: TaskRunner, willRunTaskAt index: Int) {
        let task = taskRunner.task(at: index)
        taskViewModel = delegate?.taskRunnerViewController(self, taskViewModelFor: task)
        if taskRunner.numberOfTasks > 0 {
            progress = Float(taskRunner.currentTaskIndex) / Float(taskRunner.numberOfTasks)
        } else {
            progress = 0.0
        }
    }

    public func taskRunner(_ taskRunner: TaskRunner, taskAt index: Int, didFailWithError error: Error) {
        delegate?.taskRunnerViewController(self, presentError: error, for: taskRunner.task(at: index))
    }

    public func taskRunnerDidFinish(_ taskRunner: TaskRunner) {
        progress = 1.0
        delegate?.taskRunnerViewControllerDidFinish(self)
    }
}


// MARK: -

public protocol UITaskRunnerViewControllerDelegate: class {

    /// Asks the delegate for the view model corresponding to the given task
    func taskRunnerViewController (_ controller: UITaskRunnerViewController, taskViewModelFor task: Task) -> UITaskViewModel

    /// Asks the delegate to present the given error, that is caused by the given
    /// task.
    func taskRunnerViewController (_ controller: UITaskRunnerViewController, presentError error: Error, for task: Task)

    /// Tells the delegate, that the controller has finished presenting tasks.
    func taskRunnerViewControllerDidFinish (_ controller: UITaskRunnerViewController)
}
