/// The model for the `VisusNhdInputPickerCell`.
struct VisusNhdInputPickerCellModel {
	/// When true the title will use an extra large font size (e.g. for landscape mode),
	/// while false uses the default size (e.g. for portrait).
	let largeStyle: Bool
	/// The type of value the picker represents.
	let type: VisusNhdType
	/// The value to show in the picker.
	let value: Float
	/// The delegate to inform about cell actions.
	weak var delegate: VisusNhdInputPickerCellDelegate?
}

/// The delegate protocol to inform about cell actions.
protocol VisusNhdInputPickerCellDelegate: class {
	/**
	 Informs that the picker's value has changed.

	 - parameter visusNhdInputPickerCell: The cell with the picker.
	 - parameter newValue: The changed value.
	 */
	func pickerValueChanged(onVisusNhdInputPickerCell visusNhdInputPickerCell: VisusNhdInputPickerCell, newValue: Float)
}
