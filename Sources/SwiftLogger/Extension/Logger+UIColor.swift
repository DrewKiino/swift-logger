//
//  Logger+UIColor.swift
//  Shred
//
//  Created by Drew Aquino on 11/1/22.
//

import Foundation
import UIKit

internal extension UIColor {
  static func generateCString(hexString: String) -> String {
    var cString: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    if cString.hasPrefix("#") {
      cString.remove(at: cString.startIndex)
    }
    return cString
  }
  
  static func generateRGBValue(cString: String) -> UInt64 {
    var rgbValue: UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)
    return rgbValue
  }
  
  convenience init(_ hexString: String, alpha: CGFloat = 1.0) {
    let cString = UIColor.generateCString(hexString: hexString)
    if (cString.count) != 6 {
      self.init()
    } else {
      let rgbValue = UIColor.generateRGBValue(cString: cString)
      self.init(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
      )
    }
  }
  
  var hexString: String {
    var r: CGFloat = 0
    var g: CGFloat = 0
    var b: CGFloat = 0
    var a: CGFloat = 0
    getRed(&r, green: &g, blue: &b, alpha: &a)
    let rgb: Int = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0
    return String(format: "#%06x", rgb)
  }
  
  static func random(alpha: CGFloat = .random(in: 0...1)) -> UIColor {
     return UIColor(
       red: CGFloat.random(in: 0...1),
       green: CGFloat.random(in: 0...1),
       blue: CGFloat.random(in: 0...1),
       alpha: 1.0
     ).withAlphaComponent(alpha)
   }
}
