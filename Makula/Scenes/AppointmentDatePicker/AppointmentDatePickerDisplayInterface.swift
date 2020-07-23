import Foundation

/// The display interface, which is available to the logic for updating the views.
protocol AppointmentDatePickerDisplayInterface: class {
	/**
	 Updates the display with given data to show.

	 - parameter model: The data to show.
	 */
	func updateDisplay(model: AppointmentDatePickerDisplayModel.UpdateDisplay)

	/**
	 Updates the date / time picker in the content view.

	 - parameter model: The data to show.
	 */
	func updatePickerDate(model: AppointmentDatePickerDisplayModel.PickerDate)

	/**
	 Shows an alert to inform about a writing error on the databse.
	 */
	func showDatabaseWriteError()
}
