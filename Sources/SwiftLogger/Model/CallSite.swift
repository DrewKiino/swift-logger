//
//  CallSite.swift
//  Shred
//
//  Created by Drew Aquino on 11/1/22.
//

import Foundation

public struct CallSite: Codable {
  let function: String
  let file: String
  let line: UInt
  public init(function: String, file: String, line: UInt) {
    self.function = function
    self.file = file
    self.line = line
  }
}
