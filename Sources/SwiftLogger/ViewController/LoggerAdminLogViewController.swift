//
//  LoggerAdminLogViewController.swift
//  Shred
//
//  Created by Drew Aquino on 11/1/22.
//

import Foundation
import UIKit

internal class LoggerAdminLogViewController: UIViewController {
  private lazy var textView: UITextView = {
    let view = UITextView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.textContainerInset = .zero
    return view
  }()

  private lazy var callSiteLabel: UITextView = {
    let view = UITextView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.textContainerInset = .zero
    view.isUserInteractionEnabled = false
    view.isScrollEnabled = false
    return view
  }()
  
  private let log: Log
  
  public init(_ log: Log) {
    self.log = log
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "\(self.log.logLevel.stringValue)"
    self.view.backgroundColor = .white
    
    self.edgesForExtendedLayout = []
    
    self.navigationItem.rightBarButtonItems = [
      .init(title: "Share", style: .done, target: self, action: #selector(didTapShare)),
    ]
    
    self.view.addSubview(self.callSiteLabel)
    self.view.addSubview(self.textView)
    
    let layoutMargins = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
    
    NSLayoutConstraint.activate([
      self.callSiteLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: layoutMargins.left),
      self.callSiteLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -layoutMargins.right),
      self.callSiteLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: layoutMargins.top),
      self.textView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: layoutMargins.left),
      self.textView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -layoutMargins.right),
      self.textView.topAnchor.constraint(equalTo: self.callSiteLabel.bottomAnchor, constant: 8.0),
      self.textView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -layoutMargins.bottom),
    ])
    
    self.callSiteLabel.attributedText = self.log.callSiteString.toAttributedString([
      .font: UIFont.systemFont(ofSize: 10.0, weight: .semibold),
      .foregroundColor: UIColor("#36454F")
    ])
    
    self.textView.attributedText = self.log.value.toAttributedString([
      .font: UIFont.systemFont(ofSize: 10.0, weight: .regular),
      .foregroundColor: UIColor("#36454F")
    ])
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    .darkContent
  }
  
  @objc private func didTapShare() {
    let text = self.log.consoleString
    let textToShare = [text]
    let activityViewController = UIActivityViewController(
      activityItems: textToShare,
      applicationActivities: nil
    )
    activityViewController.popoverPresentationController?.sourceView = self.view
    activityViewController.excludedActivityTypes = [
      .postToTwitter,
      .postToFacebook
    ]
    self.present(activityViewController, animated: true, completion: nil)
  }
}
