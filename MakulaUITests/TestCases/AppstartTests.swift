import XCTest

class AppstartTests: UITestCase {
	// MARK: First start

	/// The app starts with the splash scene, shows the disclaimer and finally ends on the menu scene.
	func testFirstStart() {
		launchApp()
		firstStart()
	}

	/// Same as `testFirstStart` but in landscape.
	func testFirstStartLandscape() {
		launchApp(inOrientation: .landscapeLeft)
		firstStart()
	}

	/// Navigates the app through the first start from the splash scene over the disclaimer to the menu scene.
	func firstStart() {
		// The app starts with the splash scene.
		XCTAssertTrue(app.isDisplayingSplash)

		// Wait for the automatic transition to the disclaimer happens.
		waitForNotExists(element: app.otherElements[Const.SplashTests.ViewName.mainView], timeout: 5.0)

		// The splash view shouldn't be visible anymore, but the disclaimer scene.
		XCTAssertFalse(app.isDisplayingSplash)
		XCTAssertTrue(app.isDisplayingDisclaimer)

		// Scroll the disclaimer up to show the checkbox button.
		repeatAction({
			app.scrollViews[Const.DisclaimerTests.ViewName.scrollView].swipeUp()
		}) {
			app.buttons[Const.DisclaimerTests.ViewName.checkbox].isHittable
		}
		XCTAssertTrue(app.buttons[Const.DisclaimerTests.ViewName.checkbox].isHittable)

		// Tap on the checkbox button.
		app.buttons[Const.DisclaimerTests.ViewName.checkbox].tap()

		// Tap on the confirm button.
		app.buttons[Const.DisclaimerTests.ViewName.confirmButton].tap()

		// Wait for the transition.
		waitForNotExists(element: app.otherElements[Const.DisclaimerTests.ViewName.mainView], timeout: 5.0)

		// Menu scene should now be visible.
		XCTAssertFalse(app.isDisplayingDisclaimer)
		XCTAssertTrue(app.isDisplayingMenu)
	}

	// MARK: Second start

	/// The app starts with the splash scene, shows the disclaimer and finally ends on the menu scene.
	func testSecondStart() {
		launchApp(scenario: Const.TestArgument.Scenario.startedOnce)
		secondStart()
	}

	/// Same as `testSecondStart` but in landscape.
	func testSecondStartLandscape() {
		launchApp(inOrientation: .landscapeLeft, scenario: Const.TestArgument.Scenario.startedOnce)
		secondStart()
	}

	/// Navigates the app through the second start from the splash scene directly to the menu scene.
	func secondStart() {
		// The app starts with the splash scene.
		XCTAssertTrue(app.isDisplayingSplash)

		// Wait for the automatic transition to the menu happens.
		waitForNotExists(element: app.otherElements[Const.SplashTests.ViewName.mainView], timeout: 5.0)

		// The splash view shouldn't be visible anymore, but the menu scene.
		XCTAssertFalse(app.isDisplayingSplash)
		XCTAssertTrue(app.isDisplayingMenu)
	}
}
