import UIKit

/// The model for the `SearchInputCell`.
struct SearchInputCellModel {
	/// When true the cell uses a large style for text and buttons (e.g. for landscape mode),
	/// while false uses the default style (e.g. for portrait).
	let largeStyle: Bool
	/// The textfield's content text if any should be shown. Leave to `nil` to show the placeholder.
	let searchText: String?
	/// The delegate to inform about cell actions.
	weak var delegate: SearchInputCellDelegate?
}

/// The delegate protocol to inform about cell actions.
protocol SearchInputCellDelegate: class, UITextFieldDelegate {}
