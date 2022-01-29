//
//  Logger.swift
//  ChaosCore
//
//  Created by Fu Lam Diep on 18.05.21.
//

import Foundation

public class Log {

    // MARK: Nested Types

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

    public struct LevelOptions: OptionSet, ExpressibleByIntegerLiteral {

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



    // MARK: Properties

    /// Specifies for which type to log the messages. This can restrict visibility, when type is not enabled with
    /// static function `enable(types:)`.
    public let type: Any.Type?


    // MARK: Initialization

    public init (_ type: AnyClass? = nil) {
        self.type = type
    }


    // MARK: Writing Logs

    private func log (level: Level, args: [Any]) {
        guard Log.isLevelEnabled(level, forType: type) else { return }

        let message = String(format: "%@ %@ [%@]: %@",
                             Date() as NSDate,
                             type.map({ String(describing: $0) }) ?? "Global",
                             args.map({ String(describing: $0) }).joined(separator: "\n"))
        Log.delegate?.log(self, willPrintMessage: message, onLevel: level)
        Log.output.write(message: message)
        Log.delegate?.log(self, didPrintMessage: message, onLevel: level)
    }

    private func log (level: Level, format: String, args: [CVarArg]) {
        guard Log.isLevelEnabled(level, forType: type) else { return }

        let message = String(format: "%@ %@ [%@]: %@",
                             Date() as NSDate,
                             type.map({ String(describing: $0) }) ?? "Global",
                             String(format: format, arguments: args))
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

    public func debug (args: [Any]) {
        log(level: .debug, args: args)
    }

    public func debug (_ args: Any...) {
        debug(args: args)
    }

    public func info (format: String, args: [CVarArg]) {
        log(level: .info, format: format, args: args)
    }

    public func info (format: String, _ args: CVarArg...) {
        info(format: format, args: args)
    }

    public func info (args: [Any]) {
        log(level: .info, args: args)
    }

    public func info (_ args: Any...) {
        info(args: args)
    }

    public func warn (format: String, args: [CVarArg]) {
        log(level: .warn, format: format, args: args)
    }

    public func warn (format: String, _ args: CVarArg...) {
        warn(format: format, args: args)
    }

    public func warn (args: [Any]) {
        log(level: .warn, args: args)
    }

    public func warn (_ args: Any...) {
        warn(args: args)
    }

    public func error (format: String, args: [CVarArg]) {
        log(level: .error, format: format, args: args)
    }

    public func error (format: String, _ args: CVarArg...) {
        error(format: format, args: args)
    }

    public func error (args: [Any]) {
        log(level: .error, args: args)
    }

    public func error (_ args: Any...) {
        error(args: args)
    }

    public func dump<T> (_ arg: T) {
        Swift.dump(arg)
    }
}

// MARK: - Static Extension

public extension Log {

    // MARK: Nested Types

    internal struct Configuration {
        public let type: Any.Type?
        public var options: LevelOptions
    }


    // MARK: Properties

    static var output: LogOutput = PrintLogOutput()

    static weak var delegate: LogDelegate?

    private static var configurations: [Configuration] = []


    // MARK: Control Log Level by Type

    @discardableResult
    static func enable(_ levels: [Level], forType type: Any.Type? = nil) -> Log.Type {
        let levelOptions = LevelOptions(levels: levels)
        return enable(levelOptions, forType: type)
    }

    @discardableResult
    static func enable(_ levelOptions: LevelOptions, forType type: Any.Type? = nil) -> Log.Type {
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

    static func isLevelEnabled(_ level: Level, forType type: Any.Type?) -> Bool {
        configurations.first(where: { $0.type == type })?.options.contains(level: level) ?? false
    }
}
