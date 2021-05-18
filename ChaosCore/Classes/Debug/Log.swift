//
//  Logger.swift
//  ChaosCore
//
//  Created by Fu Lam Diep on 18.05.21.
//

import Foundation

public class Log {

    private var levelSet: LevelSet = LevelSet(rawValue: 0)

    public init (levels: [Log.Level]) {
        levelSet = LevelSet(rawValue: levels.reduce(0, { $0 | $1.rawValue }))
    }

    private func log (level: Level, format: String, args: [CVarArg]) {
        guard levelSet.contains(level: level) else { return }
        let message = "\(Date()) [\(level)] \(format)"
        print(String(format: message, arguments: args))
    }

    public func debug (format: String, _ args: CVarArg...) {
        log(level: .debug, format: format, args: args)
    }

    public func info (format: String, _ args: CVarArg...) {
        log(level: .info, format: format, args: args)
    }

    public func warn (format: String, _ args: CVarArg...) {
        log(level: .warn, format: format, args: args)
    }

    public func error (format: String, _ args: CVarArg...) {
        log(level: .error, format: format, args: args)
    }
}


public extension Log {
    public enum Level: Int {
        case debug = 1
        case info = 2
        case warn = 4
        case error = 8

        public var string: String {
            switch self {
            case .debug: return "DEBUG"
            case .info: return "INFO"
            case .warn: return "WARN"
            case .error: return "ERROR"
            }
        }
    }

    public struct LevelSet: OptionSet {

        public typealias RawValue = Int

        public var rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public func contains(level: Log.Level) -> Bool {
            return contains(LevelSet(rawValue: level.rawValue))
        }
    }
}
