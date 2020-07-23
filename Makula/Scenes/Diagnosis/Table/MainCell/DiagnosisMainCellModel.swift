/// The model for the `DiagnosisMainCell`.
struct DiagnosisMainCellModel {
	/// The cell's accessibility identifier.
	let accessibilityIdentifier: String
	/// The cell's index for referencing.
	let rowIndex: Int
	/// The cell's title.
	let title: String
	/// The cell's subtitle.
	let subtitle: String
	/// When true the title will use an extra large font size (e.g. for landscape mode),
	/// while false uses the default size (e.g. for portrait).
	let largeStyle: Bool
	/// The delegate to inform about cell actions.
	weak var delegate: DiagnosisMainCellDelegate?
}

/// The delegate protocol to inform about cell actions.
protocol DiagnosisMainCellDelegate: class {
	/**
	 Informs that the info button has been pressed.

	 - parameter mainCell: The cell on which the action happened.
	 - parameter index: The cell's index for referencing.
	 */
	func infoButtonPressed(onMainCell mainCell: DiagnosisMainCell, index: Int)
}
