import XCTest

/**
 The Test Case for UI tests each testing class should derive from instead of `XCTestCase` in this target.
 */
class UITestCase: XCTestCase {
	// MARK: - Base test case

	/// The app reference currently launched which is out subject under test.
	var app: XCUIApplication!

	/**
	 Creates the app and launches it in portrait.
	 */
	override func setUp() {
		super.setUp()

		app = XCUIApplication()
	}

	/**
	 Resets the app reference to nil.
	 */
	override func tearDown() {
		rotateDevice(into: .portrait, sleepFor: 0)
		app = nil
		super.tearDown()
	}
}
