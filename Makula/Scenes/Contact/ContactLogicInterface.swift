/// The logic interface, which is available to the display for starting logic work.
protocol ContactLogicInterface: class {
	// MARK: - Models

	/**
	 Assigns the setup model for the initial state.

	 - parameter model: The model.
	 */
	func setModel(_ model: ContactRouterModel.Setup)

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
	 Informs that the user has pressed the add button.

	 Adds a new entry to this scene and transitions to the contact details scene.
	 */
	func addButtonPressed()

	/**
	 Informs that a contact has been selected to show.

	 - parameter contact: The contact selected.
	 */
	func contactSelected(_ contact: ContactModel)
}
