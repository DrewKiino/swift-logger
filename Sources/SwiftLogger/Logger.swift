//
//  Logger.swift
//  Logger
//
//  Created by Andrew Aquino on 4/20/20.
//

import Combine
import Foundation
import os.log

public class Logger {
  private static var loggers: [String: Logger] = [:]
  
  public static func register(_ subject: Any) -> Logger {
    let identifier = String(describing: subject)
    if let logger = loggers[identifier] {
      return logger
    }
    let logger = Logger(identifier)
    self.loggers[identifier] = logger
    return logger
  }
  
  private var items: [Log] = []
  private var history: [Log] = []
  private var sessionCallSite: CallSite?
  private let identifier: String
  
  public init(_ identifier: String = UUID().uuidString) {
    self.identifier = identifier
  }
  
  public func setSessionCallSite(file: String, function: String, line: UInt) {
    self.sessionCallSite = CallSite(
      function: function,
      file: file,
      line: line
    )
  }
  
  public func enqueue<T>(
    level logLevel: LogLevel,
    _ value: T,
    function: String = #function,
    file: String = #file,
    line: UInt = #line
  ) {
    CoreLogger.shared.logQueue.sync {
      let callSite = sessionCallSite ?? CallSite(function: function, file: file, line: line)
      items.append(
        Log(
          identifier: identifier,
          logLevel: logLevel,
          value: value,
          callSite: callSite
        )
      )
    }
  }
  
  private func invalidLogLevel(_ logLevel: LogLevel) -> Bool {
    if let logLevels = envStringArray("LOGGER_LEVELS")?.filter(\.isNotEmpty) {
      if logLevels.isEmpty {
        return true
      }
      return !logLevels.contains(logLevel.stringValue)
    }
    return false
  }
  
  private func invalidLogIdentifier(_ identifier: String) -> Bool {
    if let identifiers = envStringArray("LOGGER_IDS")?.filter(\.isNotEmpty),
       identifiers.isNotEmpty,
       !identifiers.contains(identifier) {
      return true
    }
    return false
  }
  
  public func flush() {
    CoreLogger.shared.logQueue.sync {
      history += items
      self.items.forEach { log in
        self.printToConsole(log)
      }
      items.removeAll()
    }
  }
  
  private func printToConsole(_ log: Log) {
    if let delegate = LoggerAdmin.shared.delegate, delegate.loggerAdmin(isLogInvalid: log) {
      return
    }
    if invalidLogLevel(log.logLevel) { return }
    if invalidLogIdentifier(log.identifier) { return }
    if let delegate = LoggerAdmin.shared.delegate, delegate.loggerAdmin(skipCacheToLogBook: log) {
    } else {
      CoreLogger.shared.processLog(log)
    }
    if let delegate = LoggerAdmin.shared.delegate, delegate.loggerAdmin(skipPrintToConsole: log) {
    } else {
      os_log(
        "%@%@%@",
        log: .default,
        type: log.osLogType,
        log.traceString,
        log.delimiter,
        log.value
      )
    }
  }
  
  public func debug<T: Any>(
    _ value: T,
    function: String = #function,
    file: String = #file,
    line: UInt = #line
  ) {
    CoreLogger.shared.logQueue.sync {
      let callSite = CallSite(function: function, file: file, line: line)
      self.printToConsole(
        Log(identifier: identifier, logLevel: .debug, value: value, callSite: callSite)
      )
    }
  }
  
  public func system<T>(
    _ value: T,
    function: String = #function,
    file: String = #file,
    line: UInt = #line
  ) {
    CoreLogger.shared.logQueue.sync {
      let callSite = CallSite(function: function, file: file, line: line)
      self.printToConsole(
        Log(identifier: identifier, logLevel: .system, value: value, callSite: callSite)
      )
    }
  }
  
  public func error<T>(
    _ value: T,
    function: String = #function,
    file: String = #file,
    line: UInt = #line
  ) {
    CoreLogger.shared.logQueue.sync {
      let callSite = CallSite(function: function, file: file, line: line)
      self.printToConsole(
        Log(identifier: identifier, logLevel: .error, value: value, callSite: callSite)
      )
    }
  }
  
  public func warning<T>(
    _ value: T,
    function: String = #function,
    file: String = #file,
    line: UInt = #line
  ) {
    CoreLogger.shared.logQueue.sync {
      let callSite = CallSite(function: function, file: file, line: line)
      self.printToConsole(
        Log(identifier: identifier, logLevel: .warning, value: value, callSite: callSite)
      )
    }
  }
  
  public func info<T>(
    _ value: T,
    function: String = #function,
    file: String = #file,
    line: UInt = #line
  ) {
    CoreLogger.shared.logQueue.sync {
      let callSite = CallSite(function: function, file: file, line: line)
      self.printToConsole(
        Log(identifier: identifier, logLevel: .info, value: value, callSite: callSite)
      )
    }
  }
  
  public func verbose<T>(
    _ value: T,
    function: String = #function,
    file: String = #file,
    line: UInt = #line
  ) {
    CoreLogger.shared.logQueue.sync {
      let callSite = CallSite(function: function, file: file, line: line)
      self.printToConsole(
        Log(identifier: identifier, logLevel: .verbose, value: value, callSite: callSite)
      )
    }
  }
}
