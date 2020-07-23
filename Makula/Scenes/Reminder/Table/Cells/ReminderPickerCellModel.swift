/// The model for the `ReminderPickerCell`.
struct ReminderPickerCellModel {
	/// When true the cell uses a large style for text and buttons (e.g. for landscape mode),
	/// while false uses the default style (e.g. for portrait).
	let largeStyle: Bool
	/// The value in minutes to show in the picker.
	let value: Int
	/// The delegate to inform about cell actions.
	weak var delegate: ReminderPickerCellDelegate?
}

/// The delegate protocol to inform about cell actions.
protocol ReminderPickerCellDelegate: class {
	/**
	 Informs that the picker's value has changed.

	 - parameter reminderPickerCell: The cell with the picker.
	 - parameter newValue: The changed value in minutes.
	 */
	func pickerValueChanged(onReminderPickerCell reminderPickerCell: ReminderPickerCell, newValue: Int)
}
