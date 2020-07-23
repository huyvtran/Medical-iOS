/// The logic interface, which is available to the display for starting logic work.
protocol ReadingTestLogicInterface: class {
	// MARK: - Models

	/**
	 Assigns the setup model for the initial state.

	 - parameter model: The model.
	 */
	func setModel(_ model: ReadingTestRouterModel.Setup)

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
	 Informs that the user has pressed the back button.

	 Routes to the information scene.
	 */
	func infoButtonPressed()
}
