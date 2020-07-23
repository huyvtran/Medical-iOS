@testable import Makula
import XCTest

class DelegatedCallTests: TestCase {
	// MARK: - Types

	/// A simple object to pass as parameter the delegate is interested in.
	class TestObject {}

	/// A delegate mock which is interested in the sut's callback.
	class DelegateMock {}

	// MARK: - Setup

	/// The util under test.
	var sut: DelegatedCall<TestObject>!

	override func setUp() {
		super.setUp()

		sut = DelegatedCall<TestObject>()
	}

	override func tearDown() {
		sut = nil
		super.tearDown()
	}

	// MARK: - Tests

	/// The delegate will be informed.
	func testInformDelegate() {
		// The data to pass.
		let testObject = TestObject()

		// Create the delegate.
		let delegateObject = DelegateMock()

		// Register delegate and expect it get informed.
		let informDelegateExpectation = expectation(description: "informDelegateExpectation")
		sut.setDelegate(to: delegateObject) { _, testObjectPassed in
			XCTAssert(testObject === testObjectPassed)
			informDelegateExpectation.fulfill()
		}

		// Method under test.
		sut.callback?(testObject)

		// Assure expectations.
		waitForExpectations(timeout: 1)
	}

	/// The delegate object is not retained.
	func testDelegateObjectNotRetained() {
		// Create the reference object for the delegate and assure we have a weak reference on it.
		var strongDelegate: DelegateMock? = DelegateMock()
		weak var weakDelegate: DelegateMock? = strongDelegate
		XCTAssertNotNil(weakDelegate)

		// Assign delegate.
		sut.setDelegate(to: strongDelegate!) { _, _ in
		}

		// Remove the strong reference.
		strongDelegate = nil

		// Assure the weak reference is also gone.
		XCTAssertNil(weakDelegate)
	}

	/// Informing a released delegate shouldn't crash.
	func testCallReleasedDelegate() {
		// Create the reference object for the delegate.
		var strongDelegate: DelegateMock? = DelegateMock()

		// Assign delegate.
		sut.setDelegate(to: strongDelegate!) { _, _ in
		}

		// Remove the strong reference to dealloc the delegate.
		strongDelegate = nil

		// Try to inform the delegate.
		XCTAssertNotNil(sut.callback)
		let testObject = TestObject()
		XCTAssertNoThrow(sut.callback?(testObject))
	}
}
