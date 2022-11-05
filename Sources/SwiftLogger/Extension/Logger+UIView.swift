//
//  Logger+UIView.swift
//  Shred
//
//  Created by Drew Aquino on 11/1/22.
//

import Foundation
import UIKit

internal extension UIView {
  func anchorToSuperview(inset: UIEdgeInsets = .zero) {
    self.translatesAutoresizingMaskIntoConstraints = false
    let superview = self.superview!
    let constraints = [
      self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: inset.left),
      self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -inset.right),
      self.topAnchor.constraint(equalTo: superview.topAnchor, constant: inset.top),
      self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -inset.bottom)
    ]
    NSLayoutConstraint.activate(constraints)
    superview.layoutIfNeeded()
  }
}


