import XCTest

extension UITestCase {
	// MARK: - App launch

	/**
	 Launches the app with the device in a specific orientation.
	 One of the launch methods have to be called on each test, but only once per test.

	 - parameter orientation: The device's orientation, defaults to `portrait`.
	 - parameter scenario: The test scenario to set up the app for.
	 If `nil` (default) then no specific scenario will be used so only the persisted app settings will be erased.
	 */
	func launchApp(inOrientation orientation: UIDeviceOrientation = .portrait, scenario: Const.TestArgument.Scenario? = nil) {
		rotateDevice(into: orientation)
		app.configureArguments(scenario: scenario)
		app.launch()
	}

	// MARK: - Device orientation

	/**
	 Rotates the simulator device into a given orientation and waits for some time so the orientation animation has time to finish before continuing.
	 Does nothing if the device is already facing the given orientation, not even waiting.

	 - parameter orientation: The new orientation to rotate the device into.
	 - parameter sleepTime: The duration in seconds to wait after rotating. Defaults to 0.3 seconds.
	 */
	func rotateDevice(into orientation: UIDeviceOrientation, sleepFor sleepTime: TimeInterval = 0.3) {
		guard XCUIDevice.shared.orientation != orientation else {
			return
		}
		XCUIDevice.shared.orientation = orientation
		Thread.sleep(forTimeInterval: sleepTime)
	}

	// MARK: - Waiting methods

	/**
	 Waits for an element to become existent.

	 - parameter element: The element to wait for, e.g. `app.otherElements["myViewIdentifier"]`.
	 - parameter timeout: The number of seconds to wait before failing the test.
	 - parameter file: The file name which calls this code. Don't set a value.
	 - parameter line: The line number where this code has been called. Don't set a value.
	 */
	func waitForExists(element: XCUIElement, timeout: Double, file: String = #file, line: UInt = #line) {
		let predicate = NSPredicate(format: "exists == true")
		waitForPredicate(predicate, forElement: element, timeout: timeout, file: file, line: line)
	}

	/**
	 Waits for an element to become non existent.

	 - parameter element: The element to wait for, e.g. `app.otherElements["myViewIdentifier"]`.
	 - parameter timeout: The number of seconds to wait before failing the test.
	 - parameter file: The file name which calls this code. Don't set a value.
	 - parameter line: The line number where this code has been called. Don't set a value.
	 */
	func waitForNotExists(element: XCUIElement, timeout: Double, file: String = #file, line: UInt = #line) {
		let predicate = NSPredicate(format: "exists == false")
		waitForPredicate(predicate, forElement: element, timeout: timeout, file: file, line: line)
	}

	/**
	 Waits for an element to become hittable.

	 - parameter element: The element to wait for, e.g. `app.otherElements["myButtonIdentifier"]`.
	 - parameter timeout: The number of seconds to wait before failing the test.
	 - parameter file: The file name which calls this code. Don't set a value.
	 - parameter line: The line number where this code has been called. Don't set a value.
	 */
	func waitForHittable(element: XCUIElement, timeout: Double, file: String = #file, line: UInt = #line) {
		let predicate = NSPredicate(format: "hittable == true")
		waitForPredicate(predicate, forElement: element, timeout: timeout, file: file, line: line)
	}

	/**
	 Waits for an element to become not hittable.

	 - parameter element: The element to wait for, e.g. `app.otherElements["myButtonIdentifier"]`.
	 - parameter timeout: The number of seconds to wait before failing the test.
	 - parameter file: The file name which calls this code. Don't set a value.
	 - parameter line: The line number where this code has been called. Don't set a value.
	 */
	func waitForNotHittable(element: XCUIElement, timeout: Double, file: String = #file, line: UInt = #line) {
		let predicate = NSPredicate(format: "hittable == false")
		waitForPredicate(predicate, forElement: element, timeout: timeout, file: file, line: line)
	}

	/**
	 Waits for an element so the predicate evaluates to `true`.

	 - parameter predicate: The predicate to evaluate.
	 - parameter element: The element to wait for.
	 - parameter timeout: The number of seconds to wait before failing the test.
	 - parameter file: The file name which calls this code. Don't set a value.
	 - parameter line: The line number where this code has been called. Don't set a value.
	 */
	private func waitForPredicate(_ predicate: NSPredicate, forElement element: XCUIElement, timeout: Double, file: String = #file, line: UInt = #line) {
		expectation(for: predicate, evaluatedWith: element, handler: nil)

		waitForExpectations(timeout: timeout) { error -> Void in
			if error != nil {
				let message = "Waiting test failed for \(element) after \(timeout) seconds."
				self.recordFailure(withDescription: message, inFile: file, atLine: Int(line), expected: true)
			}
		}
	}

	// MARK: - Repeating actions

	/**
	 Repeats an action until a condition is met, but not more than a given threshold.

	 Use this for example to repeat a swipe gesture until is hittable without risking an ininite loop.

	 - parameter action: The action block to execute each loop.
	 - parameter maxRepeats: The threshold which caps the number of loops to a maximum value.
	 - parameter condition: The condition the loop is trying to seek.
	 */
	func repeatAction(_ action: () -> Void, maxRepeats: Int = 10, until condition: () -> Bool) {
		var loopCounter = 0
		while loopCounter < maxRepeats && !condition() {
			action()
			loopCounter += 1
		}
	}
}
