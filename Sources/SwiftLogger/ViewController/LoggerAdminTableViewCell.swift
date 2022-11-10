//
//  LoggerAdminTableViewCell.swift
//  Shred
//
//  Created by Drew Aquino on 11/1/22.
//

import Foundation
import UIKit

internal class LoggerAdminTableViewCell: UITableViewCell {
  internal static let reuseIdentifier = "LoggerAdminTableViewCell"
  
  public let containerBackgroundView: UIView = {
    let view = UIView()
    view.backgroundColor = .clear
    return view
  }()
  
  private lazy var verbosityLabel: UITextView = {
    let view = UITextView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.cornerRadius = 16.0 / 2.0
    view.clipsToBounds = true
    view.isScrollEnabled = false
    view.textContainerInset = .init(top: 1.0, left: 2.0, bottom: 1.0, right: 2.0)
    return view
  }()
  
  private lazy var dateLabel: UILabel = {
    let view = UILabel()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var callsiteLabel: UILabel = {
    let view = UILabel()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var logLabel: UILabel = {
    let view = UILabel()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.configureSelf()
    self.configureLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func configureSelf() {
  }
  
  private func configureLayout() {
    self.layoutMargins = UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 16.0)
    
    self.contentView.addSubview(self.containerBackgroundView)
    self.contentView.addSubview(self.verbosityLabel)
    self.contentView.addSubview(self.dateLabel)
    self.contentView.addSubview(self.callsiteLabel)
    self.contentView.addSubview(self.logLabel)
    
    let superview = self.contentView
    let layoutMargins = self.layoutMargins
    
    self.containerBackgroundView.anchorToSuperview()
    
    NSLayoutConstraint.activate([
      /// verbosity label
      self.verbosityLabel.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: layoutMargins.left),
      self.verbosityLabel.topAnchor.constraint(equalTo: superview.topAnchor, constant: layoutMargins.top),
      self.verbosityLabel.heightAnchor.constraint(equalToConstant: 16.0),
      /// date label
      self.dateLabel.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 4.0 + 68.0 + 4.0),
      self.dateLabel.topAnchor.constraint(equalTo: superview.topAnchor, constant: layoutMargins.top),
      self.dateLabel.widthAnchor.constraint(equalToConstant: 76.0),
      self.dateLabel.heightAnchor.constraint(equalToConstant: 16.0),
      /// callsite label
      self.callsiteLabel.leadingAnchor.constraint(equalTo: self.dateLabel.trailingAnchor, constant: 4.0),
      self.callsiteLabel.topAnchor.constraint(equalTo: superview.topAnchor, constant: layoutMargins.top),
      self.callsiteLabel.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -layoutMargins.right),
      self.callsiteLabel.heightAnchor.constraint(equalToConstant: 16.0),
      /// log label
      self.logLabel.topAnchor.constraint(equalTo: self.verbosityLabel.bottomAnchor, constant: 4.0),
      self.logLabel.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -layoutMargins.bottom),
      self.logLabel.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: layoutMargins.left),
      self.logLabel.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -layoutMargins.right),
    ])
    
    self.contentView.layoutIfNeeded()
  }
  
  public func configure(withLog log: Log) {
    self.verbosityLabel.attributedText = log.logLevel.stringValue.toAttributedString([
      .font: UIFont.systemFont(ofSize: 10.0, weight: .bold),
      .foregroundColor: UIColor.white
    ])
    self.verbosityLabel.backgroundColor = UIColor(log.logLevel.colorHexString)
    self.dateLabel.attributedText = log.loggedAt.toRelativeDateString().toAttributedString([
      .font: UIFont.systemFont(ofSize: 10.0, weight: .regular),
      .foregroundColor: UIColor("#36454F")
    ])
    self.callsiteLabel.attributedText = log.callSiteString.toAttributedString([
      .font: UIFont.systemFont(ofSize: 10.0, weight: .regular),
      .foregroundColor: UIColor("#36454F")
    ])
    self.logLabel.attributedText = (log.nonDelimitedJSONString ?? log.value).toAttributedString([
      .font: UIFont.systemFont(ofSize: 10.0, weight: .semibold),
      .foregroundColor: UIColor("#36454F")
    ])
  }
}
