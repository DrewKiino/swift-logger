//
//  Logger+String.swift
//  
//
//  Created by Drew Aquino on 11/4/22.
//

import Foundation

extension String {
  var isValidJsonString: Bool {
    if let data = self.data(using: .utf8), (try? JSONSerialization.jsonObject(with: data, options: [])) != nil {
      return true
    }
    return false
  }
  var isNotEmpty: Bool {
    !self.isEmpty
  }
  func toAttributedString(
    _ attributes: [NSAttributedString.Key: Any] = [:],
    isHTML: Bool = false
  ) -> NSAttributedString {
    if isHTML, let data = self.data(using: .utf8), let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
      return attributedString
    }
    return NSAttributedString(string: self, attributes: attributes)
  }
}

extension [String] {
  var isNotEmpty: Bool {
    !self.isEmpty
  }
}
