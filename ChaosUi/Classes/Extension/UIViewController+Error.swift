//
//  UIViewController+Error.swift
//  ChaosUi
//
//  Created by Fu Lam Diep on 26.10.20.
//

import Foundation

public extension UIViewController {
    @objc
    open func present (error: Error, title: String? = nil) {
        let controller = alertController(message: error.localizedDescription, title: title, actions: [.ok()], style: .alert)
        present(controller, animated: true, completion: nil)
    }
}
