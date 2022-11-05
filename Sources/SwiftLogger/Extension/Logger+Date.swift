//
//  Logger+Date.swift
//  Shred
//
//  Created by Drew Aquino on 11/1/22.
//

import Foundation

internal extension Date {
  func toRelativeDateString() -> String {
    let formatter = RelativeDateTimeFormatter()
    formatter.dateTimeStyle = .named
    formatter.unitsStyle = .full
    return formatter.localizedString(for: self, relativeTo: Date())
  }
}
      
