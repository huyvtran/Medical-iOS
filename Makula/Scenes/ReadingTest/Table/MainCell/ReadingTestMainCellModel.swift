import Foundation

/// The model for the `ReadingTestMainCell`.
struct ReadingTestMainCellModel {
	/// The cell's index path for referencing.
	let indexPath: IndexPath
	/// The cell's magnitude type.
	let magnitudeType: ReadingTestMagnitudeType
	/// The content string.
	let content: String
	/// The selection state for the left radio button.
	let leftSelected: Bool
	/// The selection state for the right radio button.
	let rightSelected: Bool
	/// When true the cell uses a large style for text and buttons (e.g. for landscape mode),
	/// while false uses the default style (e.g. for portrait).
	let largeStyle: Bool
	/// The delegate to inform about cell actions.
	weak var delegate: ReadingTestMainCellDelegate?
}

/// The delegate protocol to inform about cell actions.
protocol ReadingTestMainCellDelegate: class {
	/**
	 Informs that the left button has been pressed.

	 - parameter mainCell: The cell on which the action happened.
	 - parameter indexPath: The cell's index path for referencing.
	 */
	func leftButtonPressed(onMainCell mainCell: ReadingTestMainCell, indexPath: IndexPath)

	/**
	 Informs that the right button has been pressed.

	 - parameter mainCell: The cell on which the action happened.
	 - parameter indexPath: The cell's index path for referencing.
	 */
	func rightButtonPressed(onMainCell mainCell: ReadingTestMainCell, indexPath: IndexPath)
}
