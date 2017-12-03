//
//  Logger.swift
//  Claudio
//
//  Created by Michael Pace on 12/2/17.
//  Copyright © 2017 Michael Pace. All rights reserved.
//

import Foundation

/// A struct which logs formatted messages to the console, as long as their associated `LogLevel` matches or exceeds `minimumLogLevel`.
/// - note: Adapted from http://oleb.net/blog/2016/05/default-arguments-in-protocols/
struct Logger {

    /// The minimum level required in order to log a message. Defaults to `.debug`.
    static var minimumLogLevel: LogLevel = .debug

    /// Logs a message to the console, provided the supplied `logLevel` exceeds `Logger.minimumLogLevel`.
    ///
    /// - Parameters:
    ///   - logLevel: The level at which to log the message.
    ///   - message: The message to log.
    ///   - file: The file in which the log request is taking place. Defaults to `#file`.
    ///   - line: The line on which the log request is taking place. Defaults to `#line`.
    ///   - function: The function in which the log request is taking place. Defaults to `#function`.
    static func log(_ logLevel: LogLevel, _ message: @autoclosure () -> String, file: StaticString = #file, line: Int = #line, function: StaticString = #function) {
        guard logLevel.rawValue >= minimumLogLevel.rawValue else { return }

        print("\(logLevel) – \(file):\(line) – \(function) ➡️ \(message())")
    }
}

// MARK: - Nested types

extension Logger {

    /// Encapsulates possible log levels.
    ///
    /// - debug: Use for messages which may be helpful for debugging.
    /// - info: Use for messages which may be helpful for understanding the app, e.g., entry and exit points in key areas of the application.
    /// - warning: Use for messages which indicate that the app may reach an invalid state.
    /// - error: Use for messages which indicate that the app has encountered an error.
    enum LogLevel: Int, CustomStringConvertible {
        case debug = 0
        case info = 1
        case warning = 2
        case error = 3

        var description: String {
            switch self {
            case .debug:
                return "debug"
            case .info:
                return "ℹ️"
            case .warning:
                return "⚠️"
            case .error:
                return "🚨"
            }
        }
    }

}
