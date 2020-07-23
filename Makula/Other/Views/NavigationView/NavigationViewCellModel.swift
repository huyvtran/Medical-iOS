import UIKit

/// The model for the `NavigationViewCell`.
struct NavigationViewCellModel {
	/// The navigation's title.
	let title: String
	/// The color of the navigation's title and its separator.
	let color: UIColor
	/// When `true` an extra large font size (e.g. for landscape mode) and scaled icons will be used,
	/// while `false` the default size (e.g. for portrait) uses.
	let largeStyle: Bool
	/// The visibility of the separator line. Set to `false` to hide it, `true` to show it.
	let separatorVisible: Bool
	/// The visibility of the left button. Set to `false` to hide it, `true` to show it.
	let leftButtonVisible: Bool
	/// The type of button the left button shows.
	var leftButtonType: ImageButton.ImageButtonType?
	/// The visibility of the right button. Set to `false` to hide it, `true` to show it.
	let rightButtonVisible: Bool
	/// The type of button the right button shows.
	let rightButtonType: ImageButton.ImageButtonType?
	/// The delegate to inform about cell actions.
	weak var delegate: NavigationViewCellDelegate?
}

/// The delegate protocol to inform about cell actions.
protocol NavigationViewCellDelegate: class {
	/**
	 Informs that the left button has been pressed.

	 - parameter navigationViewCell: The cell on which the action happened.
	 */
	func leftButtonPressed(onNavigationViewCell navigationViewCell: NavigationViewCell)

	/**
	 Informs that the right button has been pressed.

	 - parameter navigationViewCell: The cell on which the action happened.
	 */
	func rightButtonPressed(onNavigationViewCell navigationViewCell: NavigationViewCell)
}
