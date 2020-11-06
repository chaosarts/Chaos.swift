//
//  File.swift
//  ChaosUi
//
//  Created by Fu Lam Diep on 26.10.20.
//

import Foundation

public protocol UITaskViewControllerProtocol {
    var progress: Float { get set }
    func present (task: UITaskViewModel)
}

public typealias UITaskViewController = UIViewController & UITaskViewControllerProtocol
