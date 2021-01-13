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

    /// Provides the object that serves the tasks to the internal task runner.
    public weak var taskSource: TaskRunnerSource? {
        get { taskRunner.taskSource }
        set { taskRunner.taskSource = newValue }
    }

    /// Provides the task runner to use to execute tasks.
    public private(set) lazy var taskRunner: TaskRunner = {
        let runner = TaskRunner()
        runner.delegate = self
        return runner
    } ()


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


    // MARK: View Properties

    /// Provides the label that displays the task title.
    @IBOutlet private weak var taskTitleLabel: UILabel?

    /// Provides the label that displays the task detail.
    @IBOutlet private weak var taskDetailLabel: UILabel?

    /// Provides the image view to display the task image.
    @IBOutlet private weak var taskImageView: UIImageView?

    /// Provides the progress view to display the progress of the task runner.
    @IBOutlet private weak var progressView: UIProgressView?
}


// MARK: -

extension UITaskRunnerViewController: TaskRunnerDelegate {
    public func taskRunner(_ taskRunner: TaskRunner, willRunTaskAt index: Int) {
        let task = taskRunner.task(at: index)

        taskTitleText = delegate?.taskRunnerViewController?(self, titleForTaskAt: index)
        taskDetailText = delegate?.taskRunnerViewController?(self, detailForTaskAt: index)
        taskImage = delegate?.taskRunnerViewController?(self, imageForTaskAt: index)

        if taskRunner.numberOfTasks > 0 {
            progress = Float(taskRunner.currentTaskIndex) / Float(taskRunner.numberOfTasks)
        } else {
            progress = 0.0
        }
    }

    public func taskRunner(_ taskRunner: TaskRunner, taskAt index: Int, didFailWithError error: Error) {
        let task = taskRunner.task(at: index)
        let targetMethod = task.id.snakecased()
        delegate?.taskRunnerViewController?(self, present: error, forTaskAt: index)
    }

    public func taskRunnerDidFinish(_ taskRunner: TaskRunner) {
        progress = 1.0
        delegate?.taskRunnerViewControllerDidFinish?(self)
    }
}


// MARK: -

@objc public protocol UITaskRunnerViewControllerDelegate: class, NSObjectProtocol {

    /// Asks the delegate for the title to display for the task corresponding to
    /// given id.
    @objc optional func taskRunnerViewController (_ controller: UITaskRunnerViewController, titleForTaskAt index: Int) -> String?

    /// Asks the delegate for the detail text to display for the task
    /// corresponding to given id.
    @objc optional func taskRunnerViewController (_ controller: UITaskRunnerViewController, detailForTaskAt index: Int) -> String?

    /// Asks the delegate for the image to display for the task corresponding to
    /// given id.
    @objc optional func taskRunnerViewController (_ controller: UITaskRunnerViewController, imageForTaskAt index: Int) -> UIImage?

    /// Asks the delegate to present the given error, that is caused by the given
    /// task.
    @objc optional func taskRunnerViewController (_ controller: UITaskRunnerViewController, present error: Error, forTaskAt index: Int)

    /// Tells the delegate, that the controller has finished presenting tasks.
    @objc optional func taskRunnerViewControllerDidFinish (_ controller: UITaskRunnerViewController)
}
