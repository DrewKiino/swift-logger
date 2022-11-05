//
//  Logger+Function.swift
//  
//
//  Created by Drew Aquino on 11/4/22.
//

import Foundation

func envString(_ key: String) -> String? {
  if let value = ProcessInfo.processInfo.environment[key.uppercased()], value.isNotEmpty {
    return value
  }
  return nil
}

func envStringArray(_ key: String) -> [String]? {
  if let value = ProcessInfo.processInfo.environment[key.uppercased()], value.isNotEmpty {
    return value.components(separatedBy: ",")
      .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
  }
  return nil
}
