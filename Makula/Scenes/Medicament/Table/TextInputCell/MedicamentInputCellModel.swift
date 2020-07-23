import UIKit

/// The mode for the `MedicamentInputCell`.
struct MedicamentInputCellModel {
	/// When true the title will use an extra large font size (e.g. for landscape mode),
	/// while false uses the default size (e.g. for portrait).
	let largeStyle: Bool
	/// The delegate to inform about cell actions.
	weak var delegate: MedicamentInputCellDelegate?
}

/// The delegate protocol to inform about cell actions.
protocol MedicamentInputCellDelegate: class, UITextFieldDelegate {}
