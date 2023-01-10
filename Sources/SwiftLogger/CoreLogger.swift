//
//  CoreLogger.swift
//  Shred
//
//  Created by Drew Aquino on 11/1/22.
//

import Foundation

private  let coreLoggerLogsKey = "Logger.CoreLogger.logs"

internal class CoreLogger {
  internal struct LogBook: Codable {
    internal init(logs: [Log], writtenAt: Date) {
      self.logs = logs
      self.writtenAt = writtenAt
    }
    let logs: [Log]
    let writtenAt: Date
  }

  internal static let shared = CoreLogger()
    
  public let logQueue = DispatchQueue(label: "Logger.queue", qos: .background)
  private let userDefaults: UserDefaults
  
  internal private(set) var logBook: LogBook
  
  internal var documentURL: URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
      .appendingPathComponent("shred-logs.txt")
  }
  
  private init() {
    let userDefaults = UserDefaults.standard
    if let data = userDefaults.data(forKey: coreLoggerLogsKey) {
      if let logBook = try? JSONDecoder().decode(LogBook.self, from: data) {
        self.logBook = logBook
      }
    }
    self.userDefaults = userDefaults
    self.logBook = LogBook(logs: [], writtenAt: Date())
  }

  internal func processLog(_ log: Log) {
    /// Write to log file
    self.writeToLogFile(log.value)
    /// Append to console logs
    self.logBook = LogBook(
      logs: {
        var logs = self.logBook.logs
        /// Remove logs that are older than 2 days
        if let log = logs.first, log.loggedAt.timeIntervalSinceNow + (3600 * 48) < 0 {
          logs.removeFirst()
        }
        logs.append(log)
        return logs
      }(),
      writtenAt: self.logBook.writtenAt
    )
    /// Save log book
    self.saveLogBook()
  }
  
  private func writeToLogFile(_ string: String) {
    let log = self.documentURL
    if let handle = try? FileHandle(forWritingTo: log) {
      handle.seekToEndOfFile()
      handle.write(string.data(using: .utf8)!)
      handle.closeFile()
    } else {
      try? string.data(using: .utf8)?.write(to: log, options: .atomic)
    }
  }
  
  private func saveLogBook() {
    let savedLogBook = LogBook(
      logs: self.logBook.logs,
      writtenAt: Date()
    )
    if let data = try? JSONEncoder().encode(savedLogBook) {
      self.userDefaults.setValue(data, forKey: coreLoggerLogsKey)
    }
  }
}
