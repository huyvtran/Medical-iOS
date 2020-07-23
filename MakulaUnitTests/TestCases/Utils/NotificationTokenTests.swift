@testable import Makula
import XCTest

class NotificationTokenTests: TestCase {
	// MARK: - Setup

	/// The util under test.
	var sut: NotificationToken!

	// MARK: - Tests

	/// Posting a notification triggers the observer.
	func testNotificationExecutesClosure() {
		// The notification to send.
		let sendingNotification = Notification(name: .TestNotification1)

		// Expect the closure gets fired by the notification.
		let notificationObserveExpectation = expectation(description: "notificationObserveExpectation")
		sut = NotificationCenter.default.observe(name: .TestNotification1) { notification in
			XCTAssert(sendingNotification == notification)
			notificationObserveExpectation.fulfill()
		}

		// Post the notification.
		NotificationCenter.default.post(sendingNotification)

		// Assure expectations.
		waitForExpectations(timeout: 1)
	}

	/// Posting a not matching notification doesn't triggers the observer.
	func testWrongNotificationDoesNotExecutesClosure() {
		// The notification to send.
		let sendingNotification = Notification(name: .TestNotification2)

		// Expect the closure not to get fired by the notification.
		let notificationObserveExpectation = expectation(description: "notificationObserveExpectation")
		notificationObserveExpectation.isInverted = true
		sut = NotificationCenter.default.observe(name: .TestNotification3) { _ in
			XCTFail()
			notificationObserveExpectation.fulfill()
		}

		// Post the notification.
		NotificationCenter.default.post(sendingNotification)

		// Assure expectations.
		waitForExpectations(timeout: 1)
	}

	/// Posting a notification when the token has been release doesn't triggers the observer.
	func testReleasedTokenDoesNotExecutesClosure() {
		// The notification to send.
		let sendingNotification = Notification(name: .TestNotification4)

		// Expect the closure not to get fired by the notification.
		let notificationObserveExpectation = expectation(description: "notificationObserveExpectation")
		notificationObserveExpectation.isInverted = true
		sut = NotificationCenter.default.observe(name: .TestNotification4) { _ in
			XCTFail()
			notificationObserveExpectation.fulfill()
		}

		// Release the notification token.
		sut = nil

		// Post the notification.
		NotificationCenter.default.post(sendingNotification)

		// Assure expectations.
		waitForExpectations(timeout: 1)
	}
}

/// Custom notifications for testing, each test case should use its own notification to not have any concurrency problems.
extension Notification.Name {
	static let TestNotification1 = Notification.Name("TestNotification1")
	static let TestNotification2 = Notification.Name("TestNotification2")
	static let TestNotification3 = Notification.Name("TestNotification3")
	static let TestNotification4 = Notification.Name("TestNotification4")
}
