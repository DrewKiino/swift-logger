//
//  LoggerAdminViewController.swift
//  Shred
//
//  Created by Drew Aquino on 11/1/22.
//

import Foundation
import UIKit

private let loggerAdminViewFilterStringKey = "LoggerAdminViewController.filterString"

private var loggerAdminClearedAt: Date?
private var fileToColorHexString: [String: String] = [:]

public class LoggerAdminViewController: UIViewController {
  private let logger = CoreLogger.shared
  
  private var logs: [Log] = []
  
  private lazy var tableView: UITableView = {
    let view = UITableView()
    view.delegate = self
    view.dataSource = self
    view.register(LoggerAdminTableViewCell.self, forCellReuseIdentifier: LoggerAdminTableViewCell.reuseIdentifier)
    view.refreshControl = self.refreshControl
    return view
  }()
  
  private lazy var refreshControl: UIRefreshControl = {
    let control = UIRefreshControl()
    control.addTarget(self, action: #selector(didPullDownToRefresh), for: .valueChanged)
    return control
  }()
  
  private let userDefauls: UserDefaults = .standard
  
  private var filterString: String {
    get { self.userDefauls.string(forKey: loggerAdminViewFilterStringKey) ?? "" }
    set { self.userDefauls.set(newValue, forKey: loggerAdminViewFilterStringKey) }
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
           
    self.title = "Log Book"
    self.view.backgroundColor = .white
    
    self.navigationItem.leftBarButtonItem = .init(title: "Close", style: .done, target: self, action: #selector(didTapClose))
    self.navigationItem.rightBarButtonItems = [
      .init(title: "More", style: .done, target: self, action: #selector(didTapMore)),
      .init(title: "Filter", style: .done, target: self, action: #selector(didTapFilter)),
    ]
    
    self.configureLayout()
    
    self.reloadData()
  }
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  private func configureLayout() {
    self.view.addSubview(self.tableView)
    self.tableView.anchorToSuperview()
  }
  
  @objc private func didPullDownToRefresh(_ control: UIRefreshControl) {
    loggerAdminClearedAt = nil
    self.reloadData()
    control.endRefreshing()
  }
  
  @objc private func didTapClose() {
    self.dismiss(animated: true)
  }
  
  @objc private func didTapMore() {
    let alert = UIAlertController(title: "More", message: nil, preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "Share", style: .default) { [weak self] _ in
      guard let self = self else { return }
      self.didTapShare()
    })
    alert.addAction(UIAlertAction(title: "Clear", style: .default) { [weak self] _ in
      guard let self = self else { return }
      self.didTapClear()
    })
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in })
    self.present(alert, animated: true)
  }
  
  @objc private func didTapClear() {
    loggerAdminClearedAt = Date()
    self.reloadData()
  }
  
  @objc private func didTapFilter() {
    let alert = UIAlertController(
      title: "Filter",
      message: nil,
      preferredStyle: .alert
    )
    alert.addTextField { [weak self] (textField) in
      guard let self = self else { return }
      textField.text = self.filterString
      textField.placeholder = "Filter logs containing text"
    }
    alert.addAction(UIAlertAction(title: "CLEAR", style: .default, handler: { [weak self] action in
      guard let self = self else { return }
      self.setFilterString("")
    }))
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self, weak alert] action in
      guard let self = self, let alert = alert else { return }
      let text = alert.textFields?.first?.text ?? ""
      self.setFilterString(text)
    }))
    self.present(alert, animated: true)
  }
  
  private func setFilterString(_ string: String) {
    self.filterString = string
    self.reloadData()
  }
  
  private func reloadData() {
    let filterString = self.filterString
    if filterString.isEmpty {
      self.logs = self.logger.logBook.logs.filter { log in
        if let loggerAdminClearedAt = loggerAdminClearedAt, log.loggedAt < loggerAdminClearedAt {
          return false
        }
        return true
      }.reversed()
    } else {
      self.logs = self.logger.logBook.logs.filter { log in
        if let loggerAdminClearedAt = loggerAdminClearedAt, log.loggedAt < loggerAdminClearedAt {
          return false
        }
        return log.value.lowercased().contains(filterString)
        || log.callSiteString.lowercased().contains(filterString)
        || log.logLevel.stringValue.lowercased().contains(filterString)
      }.reversed()
    }
    self.tableView.reloadData()
  }
  
  @objc private func didTapShare() {
    let text = self.logs.reversed().reduce("", { result, log in
      "\(result)\n\(log.consoleString)"
    })
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

extension LoggerAdminViewController: UITableViewDelegate, UITableViewDataSource {
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.logs.count
  }
  
  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50.0
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: LoggerAdminTableViewCell.reuseIdentifier) as? LoggerAdminTableViewCell {
      let log = self.logs[indexPath.row]
      let fileName = log.callSite.file
      cell.configure(withLog: log)
      cell.containerBackgroundView.backgroundColor = {
        if let colorHexString = fileToColorHexString[fileName] {
          return UIColor(colorHexString)
        }
        let random = UIColor.random(alpha: 0.05)
        fileToColorHexString[fileName] = random.hexString
        return random
      }()
      return cell
    }
    return .init()
  }
  
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let log = self.logs[indexPath.row]
    let viewController = LoggerAdminLogViewController(log)
    self.navigationController?.pushViewController(viewController, animated: true)
  }
}
