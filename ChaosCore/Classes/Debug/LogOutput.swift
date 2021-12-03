//
//  LogOutput.swift
//  ChaosCore
//
//  Created by Fu Lam Diep on 03.12.21.
//

import Foundation
import os

public protocol LogOutput {
    func write(message: String)
}

public struct PrintLogOutput: LogOutput {
    public func write(message: String) {
        Swift.print(message)
    }
}

public struct OSLogOutput: LogOutput {
    public func write(message: String) {
        os_log("\(message)")
    }
}
