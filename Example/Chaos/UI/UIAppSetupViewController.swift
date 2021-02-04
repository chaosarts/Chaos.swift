//
//  UIAppSetupViewController.swift
//  Chaos_Example
//
//  Created by Fu Lam Diep on 12.11.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import ChaosCore
import ChaosUi

public class UIAppSetupViewController: UIViewController, UITaskRunnerViewControllerDelegate,
                                       TaskRunnerSource {

    private var taskRunnerViewController: UITaskRunnerViewController!

    private var taskTitles = ["Loading Stops", "Loading Zones"]

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if let taskRunnerViewController = segue.destination as? UITaskRunnerViewController {
            self.taskRunnerViewController = taskRunnerViewController
            self.taskRunnerViewController.delegate = self
            self.taskRunnerViewController.taskSource = self
        }
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        taskRunnerViewController.taskRunner.resume()
    }

    // MARK: TaskRunnerTaskSource

    public func numberOfTasks(_ taskRunner: TaskRunner) -> Int {
        taskTitles.count
    }

    public func taskRunner(_ taskRunner: TaskRunner, taskAtIndex index: Int) -> Task {
        BlockTask(id: UUID().uuidString, preserveResult: true) { () -> Promise<Void> in
            return Promise { fulfill, reject -> Void in
                Timer.scheduledTimer(withTimeInterval: TimeInterval.random(in: 1..<2), repeats: false, block: { _ in
                    let void: Void
                    fulfill(void)
                })
            }
        }
    }


    // MARK: UITaskRunnerViewController Delegate
    
    public func taskRunnerViewController(_ controller: UITaskRunnerViewController, titleForTaskAt index: Int) -> String? {
        taskTitles[index]
    }

    public func taskRunnerViewController(_ controller: UITaskRunnerViewController, imageForTaskAt index: Int) -> UIImage? {
        UIImage(named: "Test")
    }

    public func taskRunnerViewController(_ controller: UITaskRunnerViewController, present error: Error, forTaskAt index: Int) {
        
    }

    public func taskRunnerViewControllerDidFinish(_ controller: UITaskRunnerViewController) {
        performSegue(withIdentifier: "MainTabBar", sender: self)
    }
}
