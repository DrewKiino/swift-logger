import XCTest
@testable import SwiftLogger

final class SwiftLoggerTests: XCTestCase {
  
  private let logger = Logger.register(SwiftLoggerTests.self)
  
  private let delegateTester = LoggerAdminDelegateTester()
  
  override func setUp() {
    LoggerAdmin.shared.delegate = delegateTester
  }
  
  func testAdminDelegate() {
    let logValue = "hello"
    
    XCTAssertNotNil(LoggerAdmin.shared.delegate)
    
    self.delegateTester.loggerAdminIsInvalidLogHandler = { log in
      XCTAssertEqual(log.value, logValue)
      return false
    }
    
    self.logger.debug(logValue)
  }
  
  func testEnqueue() {
    let logValue = "hello"
    var didCall = false
    
    self.delegateTester.loggerAdminIsInvalidLogHandler = { log in
      XCTAssertEqual(log.value, logValue)
      didCall = true
      return false
    }
    
    self.logger.enqueue(level: .debug, logValue)
    self.logger.flush()
    
    XCTAssertTrue(didCall)
  }
}

public class LoggerAdminDelegateTester: LoggerAdminDelegate {
  
  public var loggerAdminIsInvalidLogHandler: ((Log) -> Bool)!
  public func loggerAdmin(isLogInvalid log: Log) -> Bool {
    self.loggerAdminIsInvalidLogHandler(log)
  }
}
