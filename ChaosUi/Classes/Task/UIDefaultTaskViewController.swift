//
//  UIDefaultTaskViewController.swift
//  ChaosUi
//
//  Created by Fu Lam Diep on 26.10.20.
//

import Foundation
import ChaosCore

open class UIDefaultTaskViewController: UIViewController, UITaskViewControllerProtocol {

    @IBOutlet
    private weak var taskTitleLabel: UILabel?

    @IBOutlet
    private weak var taskDetailLabel: UILabel?

    @IBOutlet
    private weak var taskImageView: UIImageView?

    @IBOutlet
    private weak var progressView: UIProgressView?


    public var progress: Float = 0.0 {
        didSet { progressView?.progress = progress }
    }

    public func present(task: UITaskViewModel) {
        taskTitleLabel?.text = task.title
        taskDetailLabel?.text = task.detailText
        taskImageView?.image = task.image
    }
}
