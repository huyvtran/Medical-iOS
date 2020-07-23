/// The logic interface, which is available to the display for starting logic work.
protocol ReminderLogicInterface: class {
	// MARK: - Models

	/**
	 Assigns the setup model for the initial state.

	 - parameter model: The model.
	 */
	func setModel(_ model: ReminderRouterModel.Setup)

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
	 Informs that the user has pressed the checkbox cell to toggle its state.
	 */
	func toggleCheckbox()

	/**
	 Informs that the user has changed the picker time for the reminder.

	 - parameter newValue: The new time in minutes.
	 */
	func timePickerChanged(newValue: Int)
}
