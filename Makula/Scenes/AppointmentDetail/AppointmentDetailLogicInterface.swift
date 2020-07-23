/// The logic interface, which is available to the display for starting logic work.
protocol AppointmentDetailLogicInterface: class {
	// MARK: - Models

	/**
	 Assigns the setup model for the initial state.

	 - parameter model: The model.
	 */
	func setModel(_ model: AppointmentDetailRouterModel.Setup)

	/**
	 Assigns the speech data.

	 - parameter data: The speech data.
	 */
	func setSpeechData(data: [SpeechData])

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
	 Informs that the user has pressed the speak button.

	 This will start the speech reading the scene's text.
	 If the button is hit while a previous speech is currently in progress the speech will be stopped instead.
	 */
	func speakButtonPressed()

	/**
	 Informs that the user has selected the delete cell.

	 Will call `confirmDelete` on the display to confirm the deletion.
	 */
	func deletePressed()

	/**
	 Informs that the user has confirmed the deletion so the logic will delete all entries for the day and refresh the display.
	 */
	func deleteConfirmed()

	/**
	 Routes to the notes scene.
	 */
	func routeToNotes()
}
