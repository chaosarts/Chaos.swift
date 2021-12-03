//
//  Logger.swift
//  ChaosCore
//
//  Created by Fu Lam Diep on 18.05.21.
//

import Foundation

public class Log {

    // MARK: Internal Types

    public enum Level: Int, CaseIterable {
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


    // MARK: Properties

    /// Specifies for which type to log the messages. This can restrict visibility, when type is not enabled with static function
    /// `enable(types:)`.
    public let type: Any.Type?


    // MARK: Initialization

    public init (_ type: AnyClass? = nil) {
        self.type = type
    }


    // MARK: Writing Logs

    private func log (level: Level, format: String, args: [CVarArg]) {
        guard Log.isLevelEnabled(level, forType: type) else { return }

        var internalFormat = "\(Date())"
        if let type = type { internalFormat += " \(String(describing: type))" }
        internalFormat += "[\(level)]: \(format)"
        let message = String(format: internalFormat, arguments: args)

        Log.delegate?.log(self, willPrintMessage: message, onLevel: level)
        Log.output.write(message: message)
        Log.delegate?.log(self, didPrintMessage: message, onLevel: level)
    }

    public func debug (format: String, args: [CVarArg]) {
        log(level: .debug, format: format, args: args)
    }

    public func debug (format: String, _ args: CVarArg...) {
        debug(format: format, args: args)
    }

    public func info (format: String, args: [CVarArg]) {
        log(level: .info, format: format, args: args)
    }

    public func info (format: String, _ args: CVarArg...) {
        info(format: format, args: args)
    }

    public func warn (format: String, args: [CVarArg]) {
        log(level: .warn, format: format, args: args)
    }

    public func warn (format: String, _ args: CVarArg...) {
        warn(format: format, args: args)
    }

    public func error (format: String, args: [CVarArg]) {
        log(level: .error, format: format, args: args)
    }

    public func error (format: String, _ args: CVarArg...) {
        error(format: format, args: args)
    }

    public func dump<T> (_ arg: T) {
        Swift.dump(arg)
    }
}

// MARK: - Static Extension

public extension Log {

    // MARK: Nested Types

    public struct LevelOptions: OptionSet, ExpressibleByIntegerLiteral {

        public typealias RawValue = Int

        public typealias IntegerLiteralType = RawValue

        public var rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public init(integerLiteral value: RawValue) {
            self.init(rawValue: value)
        }

        public init(levels: [Level]) {
            self.init(rawValue: levels.reduce(0, { $0 | $1.rawValue }))
        }

        public func contains(level: Log.Level) -> Bool {
            return contains(LevelOptions(rawValue: level.rawValue))
        }

        public static var none: LevelOptions { [] }
        public static var all: LevelOptions { LevelOptions(levels: Log.Level.allCases) }
    }

    internal struct Configuration {
        public let type: Any.Type?
        public var options: LevelOptions
    }


    // MARK: Properties

    public static var output: LogOutput = PrintLogOutput()

    public static weak var delegate: LogDelegate?

    private static var configurations: [Configuration] = []


    // MARK: Control Log Level by Type

    @discardableResult
    public static func enable(_ levels: [Level], forType type: Any.Type? = nil) -> Log.Type {
        let levelOptions = LevelOptions(levels: levels)
        return enable(levelOptions, forType: type)
    }

    @discardableResult
    public static func enable(_ levelOptions: LevelOptions, forType type: Any.Type? = nil) -> Log.Type {
        add(configuration: Configuration(type: type, options: levelOptions))
        return self
    }

    @discardableResult
    internal static func add(configuration: Configuration) -> Log.Type {
        if let index = configurations.firstIndex(where: { $0.type == configuration.type }) {
            configurations[index] = configuration
        } else {
            configurations.append(configuration)
        }
        return self
    }

    public static func isLevelEnabled(_ level: Level, forType type: Any.Type?) -> Bool {
        configurations.first(where: { $0.type == type })?.options.contains(level: level) ?? false
    }
}
