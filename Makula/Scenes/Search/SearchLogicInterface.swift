/// The logic interface, which is available to the display for starting logic work.
protocol SearchLogicInterface: class {
	// MARK: - Models

	/**
	 Assigns the setup model for the initial state.

	 - parameter model: The model.
	 */
	func setModel(_ model: SearchRouterModel.Setup)

	// MARK: - Requests

	/**
	 Requests the current display data to show.

	 Will immediately call `updateDisplay(model:)` on the display to return the requested data.
	 */
	func requestDisplayData()

	/**
	 Applies the search text for the table content.

	 Will immediately call `updateDisplay(model:)` on the display to return the searched text.
	 */
	func updateSearch(searchText: String?)

	// MARK: - Actions

	/**
	 Informs that the user has pressed the back button.

	 Routes back to the previous scene.
	 */
	func backButtonPressed()

	/**
	 Routes to the info scene for a specific type.

	 - parameter infoType: The type of information which should be displayed.
	 */
	func routeToInfo(infoType: InfoType)
}
