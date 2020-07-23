@testable import Makula
import XCTest

class ControlCallbackTests: TestCase {
	// MARK: - Types

	/// A simple object to pass as parameter the delegate is interested in.
	class TestObject {}

	/// A delegate mock which is interested in the sut's callback.
	class DelegateMock {}

	/// A control element mocked to simulate an event.
	class ControlMock: UIControl {}

	// MARK: - Setup

	/// The util under test.
	var sut: ControlCallback<ControlMock>!
	/// The control mock.
	var controlMock: ControlMock!
	/// The closure which will be called when the sut receives a notification from the control.
	var controlCallbackClosure: () -> Void = {}
	// The delegate mock.
	var delegateObject: DelegateMock!

	override func setUp() {
		super.setUp()

		delegateObject = DelegateMock()
		controlMock = ControlMock()
		controlCallbackClosure = {}
		sut = ControlCallback<ControlMock>(for: controlMock, event: .allEvents, with: { [unowned self] in
			self.controlCallbackClosure()
			return self.controlMock
		})
	}

	override func tearDown() {
		sut = nil
		controlMock = nil
		delegateObject = nil
		super.tearDown()
	}

	// MARK: - Tests

	/// The delegate will be informed.
	func testInformDelegate() {
		// Register delegate and expect it get informed.
		let informDelegateExpectation = expectation(description: "informDelegateExpectation")
		sut.setDelegate(to: delegateObject) { delegateReference, control in
			XCTAssert(self.delegateObject === delegateReference)
			XCTAssert(self.controlMock === control)
			informDelegateExpectation.fulfill()
		}

		// Implicit call method under test.
		controlMock.sendActions(for: .allEvents)

		// Assure expectations.
		waitForExpectations(timeout: 1)
	}

	/// The delegate object is not retained.
	func testDelegateObjectNotRetained() {
		// Create the reference object for the delegate and assure we have a weak reference on it.
		weak var weakDelegate: DelegateMock? = delegateObject
		XCTAssertNotNil(weakDelegate)

		// Assign delegate.
		sut.setDelegate(to: delegateObject!) { _, _ in
		}

		// Remove the strong reference.
		delegateObject = nil

		// Assure the weak reference is also gone.
		XCTAssertNil(weakDelegate)
	}

	/// Informing a released delegate shouldn't crash.
	func testCallReleasedDelegate() {
		// Assign delegate.
		sut.setDelegate(to: delegateObject!) { _, _ in
		}

		// Remove the strong reference to dealloc the delegate.
		delegateObject = nil

		// Implicit call method under test to inform the delegate.
		XCTAssertNoThrow(controlMock.sendActions(for: .allEvents))
	}
}
