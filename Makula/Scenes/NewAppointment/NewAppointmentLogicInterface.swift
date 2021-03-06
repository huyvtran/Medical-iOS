/// The logic interface, which is available to the display for starting logic work.
protocol NewAppointmentLogicInterface: class {
	// MARK: - Models

	/**
	 Assigns the setup model for the initial state.

	 - parameter model: The model.
	 */
	func setModel(_ model: NewAppointmentRouterModel.Setup)

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
	 Routes to the appointment date picker scene.

	 - parameter appointment: The appointment type.
	 */
	func routeToDatePicker(appointment: AppointmentType)
}
