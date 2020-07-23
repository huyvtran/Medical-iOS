import UIKit

/// The model for the `ContactDetailsMainCell`.
struct ContactDetailsMainCellModel {
	/// The cell's accessibility identifier.
	let accessibilityIdentifier: String?
	/// The type of the cell content.
	let type: ContactInfoType
	/// The cell's title to show if the title label should be shown rather than the text field.
	let title: String?
	/// The cell's default color.
	let defaultColor: UIColor
	/// The cell's default color.
	let highlightColor: UIColor
	/// Whether the cell is editable or not.
	let editable: Bool
	/// Whether the cell has a custom action or not.
	let actable: Bool
	/// When true the title will use an extra large font size (e.g. for landscape mode),
	/// while false uses the default size (e.g. for portrait).
	let largeStyle: Bool
	/// The delegate to inform about cell actions.
	weak var delegate: ContactDetailsMainCellDelegate?
}

/// The delegate protocol to inform about cell actions.
protocol ContactDetailsMainCellDelegate: class, UITextFieldDelegate {
	/**
	 Informs that the darg indicator button has been pressed.

	 - parameter mainCell: The cell on which the button was pressed.
	 */
	func dragIndicatorButtonPressed(onMainCell mainCell: ContactDetailsMainCell)
}
