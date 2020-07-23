import UIKit

/// The display interface, which is available to the logic for updating the views.
protocol InfoDisplayInterface: class {
	/**
	 Updates the display with given data to show.

	 - parameter model: The data to show.
	 */
	func updateDisplay(model: InfoDisplayModel.UpdateDisplay)

	/**
	 Updates the visibility state of the bottom button.

	 - parameter visibile: Whether the button should be visible or hidden.
	 */
	func setBottomButtonVisible(_ visible: Bool)

	/**
	 Informs the user about an error which occurred.

	 - parameter title: The alert's title.
	 - parameter message: The alert's content.
	 */
	func showError(title: String, message: String)

	/**
	 Presents a mail controller.

	 - parameter controller: The mail controller to present.
	 */
	func presentMail(controller: UIViewController)
}
