/// The logic interface, which is available to the display for starting logic work.
protocol VisusNhdInputLogicInterface: class {
	// MARK: - Models

	/**
	 Assigns the setup model for the initial state.

	 - parameter model: The model.
	 */
	func setModel(_ model: VisusNhdInputRouterModel.Setup)

	// MARK: - Requests

	/**
	 Requests the current display data to show.

	 Will immediately call `updateDisplay(model:)` on the display to return the requested data.
	 */
	func requestDisplayData()

	/**
	 Informs the display that writing to the database failed.

	 Calls immediately `showDatabaseWriteError()` on the display.
	 */
	func databaseWriteError()

	// MARK: - Actions

	/**
	 Informs that the user has pressed the back button.

	 Routes back to the previous scene.
	 */
	func backButtonPressed()

	/**
	 Informs that the user has pressed the info button.

	 Routes to the info scene.
	 */
	func infoButtonPressed()

	/**
	 Informs that the user has pressed the confirm button.

	 Persists the values and routes to the graph scene.
	 */
	func confirmButtonPressed()

	/**
	 Informs that the user has selected the left eye to set up.
	 */
	func leftEyeSelected()

	/**
	 Informs that the user has selected the right eye to set up.
	 */
	func rightEyeSelected()

	/**
	 Informs that the user has changed the eye's value.
	 */
	func valueChanged(newValue: Float)
}
