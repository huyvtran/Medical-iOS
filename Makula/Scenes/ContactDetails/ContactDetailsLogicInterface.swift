/// The logic interface, which is available to the display for starting logic work.
protocol ContactDetailsLogicInterface: class {
	// MARK: - Models

	/**
	 Assigns the setup model for the initial state.

	 - parameter model: The model.
	 */
	func setModel(_ model: ContactDetailsRouterModel.Setup)

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
	 Informs that the user has pressed the speak button.

	 This will start the speech reading the scene's text.
	 If the button is hit while a previous speech is currently in progress the speech will be stopped instead.
	 */
	func speakButtonPressed()

	/**
	 Informs that the user has pressed the cell for the mobile phone to start an SMS.

	 Opens immediately the SMS app on the device.

	 - parameter mobileNumber: The mobile number to present for the SMS.
	 */
	func sendSms(mobileNumber: String)

	/**
	 Informs that the user has pressed the cell for making a phone call.

	 Calls immediately `askForPhoneCall(phoneNumber:)` on the display.

	 - parameter phoneNumber: The phone number to call.
	 */
	func startPhoneCall(phoneNumber: String)

	/**
	 Starts the phone call immediately.

	 - parameter phoneNumber: The phone number to call.
	 */
	func initiatePhoneCall(phoneNumber: String)

	/**
	 Informs that the user has pressed the cell for writing an email.

	 Calls immediately `showMail(emailAddress:)` on the display.

	 - parameter emailAddress: The receiver's email address.
	 */
	func sendEmail(emailAddress: String)

	/**
	 Informs that the user has pressed the cell with the website URL to open it.

	 Opens immediately the given URL in the device's web browser.

	 - parameter webAddress: The URL of the website.
	 */
	func openWeb(webAddress: String)
}
