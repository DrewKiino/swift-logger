//
//  LogLevel.swift
//  Shred
//
//  Created by Drew Aquino on 11/1/22.
//

import Foundation

public enum LogLevel: Int, Codable {
  case none
  case debug
  case system
  case error
  case warning
  case info
  case verbose
  
  public var stringValue: String {
    switch self {
    case .none: return "none"
    case .debug: return "debug"
    case .system: return "system"
    case .error: return "error"
    case .warning: return "warning"
    case .info: return "info"
    case .verbose: return "verbose"
    }
  }
  
  public var colorHexString: String {
    switch self {
    case .none: return "#ffffff"
    case .debug: return "#003399"
    case .system: return "#4c4c4c"
    case .error: return "#cc3300"
    case .warning: return "#ffcc00"
    case .info: return "  #339900"
    case .verbose: return "#660099"
    }
  }
}
