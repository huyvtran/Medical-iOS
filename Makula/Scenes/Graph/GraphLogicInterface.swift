/// The logic interface, which is available to the display for starting logic work.
protocol GraphLogicInterface: class {
	// MARK: - Models

	/**
	 Assigns the setup model for the initial state.

	 - parameter model: The model.
	 */
	func setModel(_ model: GraphRouterModel.Setup)

	// MARK: - Requests

	/**
	 Requests the current display data to show.

	 Will immediately call `updateDisplay(model:)` on the display to return the requested data.
	 */
	func requestDisplayData()

	// MARK: - Actions

	/**
	 Informs that the user has pressed the back button.

	 Routes back to the previous scene.
	 */
	func backButtonPressed()

	/**
	 Informs that the user has selected the left eye to set up.
	 */
	func leftEyeSelected()

	/**
	 Informs that the user has selected the right eye to set up.
	 */
	func rightEyeSelected()
}
