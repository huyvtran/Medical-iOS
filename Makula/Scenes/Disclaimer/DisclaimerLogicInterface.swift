/// The logic interface, which is available to the display for starting logic work.
protocol DisclaimerLogicInterface: class {
	// MARK: - Models

	/**
	 Assigns the setup model for the initial state.

	 - parameter model: The model.
	 */
	func setModel(_ model: DisclaimerRouterModel.Setup)

	// MARK: - Requests

	/**
	 Requests the current display data to show.

	 Will immediately call `updateDisplay(model:)` on the display to return the requested data.
	 */
	func requestDisplayData()

	// MARK: - Actions

	/**
	 Informs that the user has pressed the confirm button.

	 Routes to the menu scene when the disclaimer agree checkbox is selected.
	 */
	func confirmButtonPressed()

	/**
	 Informs that the disclaimer agree checkbox has been toggled.

	 - parameter checked: The new checkbox state representing whether the checkbox is checked or not.
	 */
	func checkboxButtonStateChanged(checked: Bool)
}
