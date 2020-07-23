import Foundation

/// The logic interface, which is available to the display for starting logic work.
protocol CalendarLogicInterface: class {
	// MARK: - Models

	/**
	 Assigns the setup model for the initial state.

	 - parameter model: The model.
	 */
	func setModel(_ model: CalendarRouterModel.Setup)

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
	 Informs that the user has pressed the add button.

	 Routes to the new appointment scene.
	 */
	func addButtonPressed()

	/**
	 Informs that the user has tapped on a day in the calendar.

	 - parameter date: The day's date.
	 */
	func daySelected(date: Date)
}
