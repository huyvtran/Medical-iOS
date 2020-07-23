import MessageUI

/// The display interface, which is available to the logic for updating the views.
protocol ContactDetailsDisplayInterface: class, MFMailComposeViewControllerDelegate {
	/**
	 Updates the display with given data to show.

	 - parameter model: The data to show.
	 */
	func updateDisplay(model: ContactDetailsDisplayModel.UpdateDisplay)

	/**
	 Shows an alert to inform about a writing error on the databse.
	 */
	func showDatabaseWriteError()

	/**
	 Shows an alert with a title and message text to inform the user about an error.

	 - parameter title: The alert's title.
	 - parameter message: The alert's message text.
	 */
	func showError(title: String, message: String)

	/**
	 Asks the user to confirm that calling the phone number is really intended.

	 - parameter phoneNumber: The phone number to call.
	 */
	func askForPhoneCall(phoneNumber: String)

	/**
	 Prepares an email for a given email address and shows Apple's Message UI for it.

	 - parameter emailAddress: The receiver's email address.
	 */
	func showMail(emailAddress: String)

	/**
	 Scrolls the table view to the first cell in the table view.
	 */
	func scrollToTop()

	/**
	 Highlights / De-highlights the cell represented by a given speech data model.

	 - parameter speechData: The speech data model.
	 - parameter highlight: Whether the cell should get highlighted (`true`) or de-highlighted (`false`).
	 */
	func setHighlightCell(for speechData: SpeechData, highlight: Bool)
}
