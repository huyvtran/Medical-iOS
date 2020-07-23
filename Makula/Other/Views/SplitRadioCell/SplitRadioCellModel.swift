import Foundation

/// The model for the `SplitRadioCell`.
struct SplitRadioCellModel {
	/// The cell's index path for referencing.
	let indexPath: IndexPath
	/// The title string.
	let title: String
	/// The selection state for the left radio button.
	let leftSelected: Bool
	/// The selection state for the right radio button.
	let rightSelected: Bool
	/// When true the cell uses a large style for text and buttons (e.g. for landscape mode),
	/// while false uses the default style (e.g. for portrait).
	let largeStyle: Bool
	/// Whether the button is enabled or disabled so no interaction can occur.
	let disabled: Bool
	/// The delegate to inform about cell actions.
	weak var delegate: SplitRadioCellDelegate?
}

/// The delegate protocol to inform about cell actions.
protocol SplitRadioCellDelegate: class {
	/**
	 Informs that the left button has been pressed.

	 - parameter splitRadioCell: The cell on which the action happened.
	 - parameter indexPath: The cell's index path for referencing.
	 */
	func leftButtonPressed(onSplitRadioCell splitRadioCell: SplitRadioCell, indexPath: IndexPath)

	/**
	 Informs that the right button has been pressed.

	 - parameter splitRadioCell: The cell on which the action happened.
	 - parameter indexPath: The cell's index path for referencing.
	 */
	func rightButtonPressed(onSplitRadioCell splitRadioCell: SplitRadioCell, indexPath: IndexPath)
}
