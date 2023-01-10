//
//  LoggerAdmin.swift
//  Shred
//
//  Created by Drew Aquino on 11/1/22.
//

import Foundation
import UIKit

public protocol LoggerAdminDelegate: AnyObject {
  func loggerAdmin(isAbleToPresentLogBook admin: LoggerAdmin) -> Bool
  func loggerAdmin(isLogInvalid log: Log) -> Bool
  func loggerAdmin(skipCacheToLogBook log: Log) -> Bool
  func loggerAdmin(skipPrintToConsole log: Log) -> Bool
}

public class LoggerAdmin {
  public static let shared = LoggerAdmin()
  
  private lazy var tapGesture: UITapGestureRecognizer = {
    let gesture = UITapGestureRecognizer()
    gesture.numberOfTouchesRequired = 3
    gesture.numberOfTapsRequired = 1
    gesture.addTarget(self, action: #selector(didTap))
    return gesture
  }()
  
  private weak var window: UIWindow?
  
  public weak var delegate: LoggerAdminDelegate?
  
  private init() {
    
  }
  
  public func addTriggerTo(window: UIWindow) {
    window.addGestureRecognizer(self.tapGesture)
    self.window = window
  }
  
  @objc private func didTap(_ gesture: UITapGestureRecognizer) {
    self.presentAdminView()
  }
  
  private func presentAdminView() {
    guard let delegate = self.delegate, delegate.loggerAdmin(isAbleToPresentLogBook: self) else { return }
    let viewController = LoggerAdminViewController()
    let navVC = UINavigationController(rootViewController: viewController)
    navVC.modalPresentationStyle = .fullScreen
    navVC.view.backgroundColor = .white
    navVC.navigationBar.isTranslucent = false
    navVC.navigationBar.backgroundColor = .white
    let presenter = self.window?.rootViewController?.presentedViewController ?? self.window?.rootViewController
    presenter?.present(navVC, animated: true)
  }
}
