/// The logic interface, which is available to the display for starting logic work.
protocol SplashLogicInterface: class {
	// MARK: - Models

	/**
	 Assigns the setup model for the initial state.

	 - parameter model: The model.
	 */
	func setModel(_ model: SplashRouterModel.Setup)

	// MARK: - Requests

	/**
	 Requests the current display data to show.

	 Will immediately call `updateDisplay(model:)` on the display to return the requested data.
	 */
	func requestDisplayData()

	// MARK: - Trigger

	/**
	 Informs that the view has been displayed after a transition and the logic now needs to process for the next transition.
	 This creates a counter and updates the data model if necessary. Only when both have finished the routing to the next scene happens.

	 When accessing the data model fails then the display will be informed via `showDatabaseError()`.
	 */
	func processForTransition()
}
