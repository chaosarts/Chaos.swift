//
//  LogDelegate.swift
//  ChaosCore
//
//  Created by Fu Lam Diep on 10.08.21.
//

import Foundation

public protocol LogDelegate: AnyObject {
    func log (_ log: Log, willPrintMessage message: String, onLevel level: Log.Level)
    func log (_ log: Log, didPrintMessage message: String, onLevel level: Log.Level)
}

public extension LogDelegate {
    func log (_ log: Log, willPrintMessage message: String, onLevel level: Log.Level) {}
    func log (_ log: Log, didPrintMessage message: String, onLevel level: Log.Level) {}
}
