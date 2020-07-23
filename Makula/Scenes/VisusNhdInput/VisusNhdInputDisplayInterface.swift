/// The display interface, which is available to the logic for updating the views.
protocol VisusNhdInputDisplayInterface: class {
	/**
	 Updates the display with given data to show.

	 - parameter model: The data to show.
	 */
	func updateDisplay(model: VisusNhdInputDisplayModel.UpdateDisplay)

	/**
	 Updates the value titles in the cell without reloading the whole table view.

	 - parameter model: The data to show.
	 */
	func updateValueTitle(model: VisusNhdInputDisplayModel.UpdateValueTitle)

	/**
	 Shows an alert to inform about a writing error on the databse.
	 */
	func showDatabaseWriteError()

	/**
	 Enables the confirm button making it possible for the user to save.
	 */
	func enableConfirmButton()
}
