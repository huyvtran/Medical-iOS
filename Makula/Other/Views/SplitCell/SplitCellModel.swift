import UIKit

/// The model for the `SplitCell`.
struct SplitCellModel {
	/// The title string for the left button.
	let leftTitle: String
	/// The title string for the right button.
	let rightTitle: String
	/// The cell's title text prepared for the speech synthesizer.
	let speechText: String?
	/// The selection state for the left button.
	let leftSelected: Bool
	/// The selection state for the right button.
	let rightSelected: Bool
	/// When true the cell uses a large style for text and buttons (e.g. for landscape mode),
	/// while false uses the default style (e.g. for portrait).
	let largeStyle: Bool
	/// Whether the button is enabled or disabled so no interaction can occur.
	let disabled: Bool
	/// The background color.
	let backgroundColor: UIColor
	/// The color of the separator.
	let separatorColor: UIColor
	/// The delegate to inform about cell actions.
	weak var delegate: SplitCellDelegate?
}

/// The delegate protocol to inform about cell actions.
protocol SplitCellDelegate: class {
	/**
	 Informs that the left button has been pressed.

	 - parameter splitCell: The cell on which the action happened.
	 */
	func leftButtonPressed(onSplitCell splitCell: SplitCell)

	/**
	 Informs that the right button has been pressed.

	 - parameter splitCell: The cell on which the action happened.
	 */
	func rightButtonPressed(onSplitCell splitCell: SplitCell)
}
