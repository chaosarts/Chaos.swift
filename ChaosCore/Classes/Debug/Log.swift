//
//  Logger.swift
//  ChaosCore
//
//  Created by Fu Lam Diep on 18.05.21.
//

import Foundation

public class Log {

    /// Specifies for which type to log the messages. This can restrict visibility, when type is not enabled with static function
    /// `enable(types:)`.
    public let type: AnyClass?

    /// Specifies the levels enabled for logging.
    private var levelOptions: LevelOptions = LevelOptions(rawValue: 0)

    /// Provides the list of levels to log.
    public var levels: [Log.Level] { Log.Level.allCases.filter({ levelOptions.contains(level: $0) }) }


    // MARK: Initialization

    public init (_ type: AnyClass? = nil, levels: [Log.Level] = []) {
        self.type = type
        self.levelOptions = LevelOptions(rawValue: levels.reduce(0, { $0 | $1.rawValue }))
    }


    // MARK: Control Log Levels

    /// Enables logging for the given list of log levels
    public func enable (levels: [Log.Level]) -> Self {
        for level in levels {
            let option = LevelOptions(rawValue: level.rawValue)
            levelOptions.insert(option)
        }
        return self
    }

    public func enable (_ levels: Log.Level...) -> Self {
        enable(levels: levels)
    }

    public func disable (levels: [Log.Level]) -> Self {
        for level in levels {
            let option = LevelOptions(rawValue: level.rawValue)
            levelOptions.remove(option)
        }
        return self
    }

    public func disable (_ levels: Log.Level...) -> Self {
        disable(levels: levels)
    }

    private func log (level: Level, format: String, args: [CVarArg]) {
        guard Log.isTypeEnabled(type), levelOptions.contains(level: level) else { return }

        var internalFormat = "\(Date())"
        if let type = type { internalFormat += " \(String(describing: type))" }
        internalFormat += "[\(level)]: \(format)"
        let message = String(format: internalFormat, arguments: args)

        Log.delegate?.log(self, willPrintMessage: message, onLevel: level)
        print(message)
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


public extension Log {

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

        public typealias RawValue = Int

        public typealias IntegerLiteralType = RawValue

        public var rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public init(integerLiteral value: RawValue) {
            self.init(rawValue: value)
        }

        public func contains(level: Log.Level) -> Bool {
            return contains(LevelOptions(rawValue: level.rawValue))
        }
    }
}

public extension Log {

    public static var delegate: LogDelegate?

    private static var enabledTypes: [AnyClass] = []

    public static func isTypeEnabled (_ type: AnyClass) -> Bool {
        enabledTypes.contains(where: { $0 == type })
    }

    public static func isTypeEnabled (_ type: AnyClass?) -> Bool {
        guard let type = type else { return true }
        return isTypeEnabled(type)
    }

    public static func enable (types: [AnyClass]) {
        for type in types {
            guard enabledTypes.contains(where: { $0 == type }) else { continue }
            enabledTypes.append(type)
        }
    }

    public static func enable (_ types: AnyClass...) {
        enable(types: types)
    }
}
