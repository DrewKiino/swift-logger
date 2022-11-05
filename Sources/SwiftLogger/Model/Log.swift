//
//  Log.swift
//  Shred
//
//  Created by Drew Aquino on 11/1/22.
//

import Foundation
import os.log

public struct Log: Codable {
  internal init(
    identifier: String,
    logLevel: LogLevel,
    value: Any,
    callSite: CallSite,
    loggedAt: Date = Date()
  ) {
    self.identifier = identifier
    self.logLevel = logLevel
    self.value = String(describing: value)
    self.callSite = callSite
    self.loggedAt = loggedAt
  }
  
  public let identifier: String
  public let logLevel: LogLevel
  public let value: String
  public let callSite: CallSite
  public let loggedAt: Date
  
  var callSiteString: String {
    "\(identifier) \(callSite.function) \(callSite.line)"
  }
  
  var traceString: String {
    "\(logLevel.stringValue.uppercased()) | \(callSiteString)"
  }
  
  var nonDelimitedJSONString: String? {
    if value.isValidJsonString {
      return value.replacingOccurrences(of: "\n", with: "")
    }
    return nil
  }
  
  var delimiter: String {
    if value.isValidJsonString {
      return "\n"
    }
    return " "
  }
  
  var osLogType: OSLogType {
    return .default
  }
  
  var consoleString: String {
    "\(self.traceString)\(self.delimiter)\(self.value)"
  }
}
