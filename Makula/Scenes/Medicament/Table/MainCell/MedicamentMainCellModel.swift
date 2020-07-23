/// The model for the `MedicamentMainCell`.
struct MedicamentMainCellModel {
	/// The cell's title.
	let title: String
	/// The cell's editable state. Defaults to `false`, `true` to be editable.
	let editable: Bool
	/// When true the title will use an extra large font size (e.g. for landscape mode),
	/// while false uses the default size (e.g. for portrait).
	let largeStyle: Bool
	/// The delegate to inform about cell actions.
	weak var delegate: MedicamentMainCellDelegate?
}

/// The delegate protocol to inform about cell actions.
protocol MedicamentMainCellDelegate: class {
	/**
	 Informs that the darg indicator button has been pressed.

	 - parameter mainCell: The cell on which the button was pressed.
	 */
	func dragIndicatorButtonPressed(onMainCell mainCell: MedicamentMainCell)
}
