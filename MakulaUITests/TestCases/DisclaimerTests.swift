import XCTest

class DisclaimerTests: UITestCase {
	// MARK: Checkbox sync

	/// The checkbox and the confirm button should be in sync so only when the checkbox is checked the confirm button can be pressed.
	func testCheckboxConfirmButtonSync() {
		launchApp(inOrientation: .portrait)

		// Wait for the disclaimer view to appear.
		waitForExists(element: app.otherElements[Const.DisclaimerTests.ViewName.mainView], timeout: 5.0)

		// Disclaimer scene should now be visible.
		XCTAssertTrue(app.isDisplayingDisclaimer)

		// Scroll up to show the checkbox button.
		repeatAction({
			app.scrollViews[Const.DisclaimerTests.ViewName.scrollView].swipeUp()
		}) {
			app.buttons[Const.DisclaimerTests.ViewName.checkbox].isHittable
		}
		XCTAssertTrue(app.buttons[Const.DisclaimerTests.ViewName.checkbox].isHittable)

		// The confirm button should be disabled.
		XCTAssertFalse(app.buttons[Const.DisclaimerTests.ViewName.confirmButton].isEnabled)
		// Tapping the confirm button shouldn't work.
		app.buttons[Const.DisclaimerTests.ViewName.confirmButton].tap()
		XCTAssertTrue(app.isDisplayingDisclaimer)

		// Tapping on the checkbox button should enable the confirm button.
		app.buttons[Const.DisclaimerTests.ViewName.checkbox].tap()
		XCTAssertTrue(app.buttons[Const.DisclaimerTests.ViewName.confirmButton].isEnabled)

		// Tapping on the checkbox button again should disable the confirm button.
		app.buttons[Const.DisclaimerTests.ViewName.checkbox].tap()
		XCTAssertFalse(app.buttons[Const.DisclaimerTests.ViewName.confirmButton].isEnabled)
		// Tapping the confirm button shouldn't work.
		app.buttons[Const.DisclaimerTests.ViewName.confirmButton].tap()
		XCTAssertTrue(app.isDisplayingDisclaimer)

		// Tapping on the checkbox button should enable the confirm button again.
		app.buttons[Const.DisclaimerTests.ViewName.checkbox].tap()
		XCTAssertTrue(app.buttons[Const.DisclaimerTests.ViewName.confirmButton].isEnabled)
		// Tapping the confirm button should work now.
		app.buttons[Const.DisclaimerTests.ViewName.confirmButton].tap()

		// Wait for the transition.
		waitForNotExists(element: app.otherElements[Const.DisclaimerTests.ViewName.mainView], timeout: 5.0)

		// The scene should now have been changed.
		XCTAssertFalse(app.isDisplayingDisclaimer)
	}
}
