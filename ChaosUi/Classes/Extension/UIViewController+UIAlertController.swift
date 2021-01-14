//
//  UIViewController+UIAlertViewController.swift
//  ChaosUi
//
//  Created by Fu Lam Diep on 26.10.20.
//

import UIKit

public extension UIViewController {

    @objc func presentAlert (message: String,
                            title: String? = nil,
                            actions: [UIAlertAction] = [],
                            style: UIAlertController.Style = .alert,
                            animated: Bool = true,
                            completion: (() -> Void)? = nil) {
        let controller = alertController(message: message, title: title, style: style)
        actions.forEach(controller.addAction(_:))
        present(controller, animated: animated, completion: completion)
    }

    @objc func alertController (message: String,
                               title: String? = nil,
                               actions: [UIAlertAction] = [],
                               style: UIAlertController.Style = .alert) -> UIAlertController {
        let controller = UIAlertController(title: title, message: message, preferredStyle: style)
        actions.forEach(controller.addAction(_:))
        return controller
    }
}


