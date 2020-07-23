@testable import Makula
import XCTest

class DispatchedCallTests: TestCase {
	// MARK: - Types

	/// A simple object which is responsible for the dispatched call.
	class TestObject {}

	// MARK: - Setup

	/// The util under test.
	var sut: DispatchedCall!
	/// The sut holder.
	var testObject: TestObject!

	override func setUp() {
		super.setUp()

		testObject = TestObject()
	}

	override func tearDown() {
		testObject = nil
		super.tearDown()
	}

	// MARK: - Tests

	/// The dispatched call gets executed after the delay.
	func testCallExecutesAfterDelay() {
		// Expect the dispatched call gets fired.
		let dispatchedCallExpectation = expectation(description: "dispatchedCallExpectation")
		sut = DispatchedCall(for: testObject, block: { [unowned self] object in
			XCTAssert(self.testObject === object)
			dispatchedCallExpectation.fulfill()
		})

		// Enqueue call.
		let timeInterval: TimeInterval = 0.5
		sut.enqueue(for: timeInterval)

		// Assure expectations.
		waitForExpectations(timeout: timeInterval * 2)
	}

	/// The dispatched call doesn't get executed prior the delay time.
	func testNoCallBeforeDelay() {
		// Expect the dispatched call doesn't get fired.
		let dispatchedCallExpectation = expectation(description: "dispatchedCallExpectation")
		dispatchedCallExpectation.isInverted = true
		sut = DispatchedCall(for: testObject, block: { _ in
			XCTFail()
			dispatchedCallExpectation.fulfill()
		})

		// Enqueue call.
		let timeInterval: TimeInterval = 0.5
		sut.enqueue(for: timeInterval)

		// Assure expectations.
		waitForExpectations(timeout: timeInterval / 2)
	}

	/// The dispatched call doesn't get executed when the reference object gets released.
	func testNoCallOnRelease() {
		// Expect the dispatched call doesn't get fired.
		let dispatchedCallExpectation = expectation(description: "dispatchedCallExpectation")
		dispatchedCallExpectation.isInverted = true
		sut = DispatchedCall(for: testObject, block: { _ in
			XCTFail()
			dispatchedCallExpectation.fulfill()
		})

		// Enqueue call.
		let timeInterval: TimeInterval = 0.5
		sut.enqueue(for: timeInterval)

		// Release reference object.
		testObject = nil

		// Assure expectations.
		waitForExpectations(timeout: timeInterval * 2)
	}

	/// The reference object is not retained.
	func testReferenceObjectNotRetained() {
		// Create the reference object for the delegate and assure we have a weak reference on it.
		weak var weakReferece: TestObject? = testObject
		XCTAssertNotNil(weakReferece)

		// Create the sut.
		sut = DispatchedCall(for: testObject, block: { _ in
			XCTFail()
		})

		// Release reference object.
		testObject = nil

		// Assure the weak reference is also gone.
		XCTAssertNil(weakReferece)
	}
}
