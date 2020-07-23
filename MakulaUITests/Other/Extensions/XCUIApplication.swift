import XCTest

extension XCUIApplication {
	// MARK: - Setup

	/**
	 Configures the app's arguments for running the app in test mode.

	 - parameter scenario: The test scenario to set up the app with.
	 */
	func configureArguments(scenario: Const.TestArgument.Scenario?) {
		launchArguments.append(Const.TestArgument.testMode)
		if let scenario = scenario {
			launchArguments.append(scenario.rawValue)
		}
	}

	// MARK: - View displayed

	/// `True` if the `SplashDisplay` scene's main view is visible.
	var isDisplayingSplash: Bool {
		return otherElements[Const.SplashTests.ViewName.mainView].exists
	}

	/// `True` if the `DisclaimerDisplay` scene's main view is visible.
	var isDisplayingDisclaimer: Bool {
		return otherElements[Const.DisclaimerTests.ViewName.mainView].exists
	}

	/// `True` if the `MenuDisplay` scene's main view is visible.
	var isDisplayingMenu: Bool {
		return otherElements[Const.MenuTests.ViewName.mainView].exists
	}

	// MARK: - Transition

	/**
	 Taps on a `NavigationView`'s back button.
	 */
	func tapBackOnNavigationView() {
		buttons[Const.NavigationViewTests.ViewName.leftButton].tap()
	}
}
