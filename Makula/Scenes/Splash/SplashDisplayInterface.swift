/// The display interface, which is available to the logic for updating the views.
protocol SplashDisplayInterface: class {
	/**
	 Updates the display with given data to show.

	 - parameter model: The data to show.
	 */
	func updateDisplay(model: SplashDisplayModel.UpdateDisplay)

	/**
	 Shows an alert to the user which describes the problem that the database couldn't be opened.
	 */
	func showDatabaseError()
}
