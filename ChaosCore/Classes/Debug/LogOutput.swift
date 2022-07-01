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

public extension LogOutput where Self = PrintLogOutput {
    static var print = PrintLogOutput()
}

public struct OSLogOutput: LogOutput {
    public func write(message: String) {
        os_log("\(message)")
    }
}

public extension LogOutput where Self = OSLogOutput {
    static var os = OSLogOutput()
}

public struct CombinedLogOutput: LogOutput {
    var logOutputs: [LogOutput]

    public func write(message: String) {
        logOutputs.forEach({ $0.write(message: message) })
    }
}

public extension LogOutput where Self = CombinedLogOutput {
    static func combined(outputs: [LogOutput]) -> LogOutput {
        CombinedLogOutput(logOutputs: outputs)
    }

    static func combined(_ outputs: LogOutput...) -> LogOutput {
        combined(outputs: outputs)
    }
}
