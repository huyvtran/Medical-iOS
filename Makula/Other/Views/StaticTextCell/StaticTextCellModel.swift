import UIKit

/// The model for the `StaticTextCell`.
struct StaticTextCellModel {
	/// The cell's accessibility identifier.
	let accessibilityIdentifier: String
	/// The cell's title.
	let title: String
	/// The cell's title for the speech synthesizer.
	let speechTitle: String?
	/// When true the title will use an extra large font size (e.g. for landscape mode),
	/// while false uses the default size (e.g. for portrait).
	let largeFont: Bool
	/// The color for the normal mode (not highlighted).
	let defaultColor: UIColor
	/// The color for the highlight mode. Nil to use `defaultColor`.
	let highlightColor: UIColor?
	/// The background color.
	let backgroundColor: UIColor
	/// Shows or hides the separator.
	let separatorVisible: Bool
	/// The color of the separator for the normal mode (not highlighted). Nil to use `defaultColor`.
	let separatorDefaultColor: UIColor?
	/// The color of the separator for the highlight mode. Nil to use `highlightColor`.
	let separatorHighlightColor: UIColor?
	/// Whether the cell is enabled or disabled so no highlighting can occur.
	let disabled: Bool
	/// Whether to center the text or to left align it.
	let centeredText: Bool
}
