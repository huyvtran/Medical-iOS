import UIKit

/// The public interface for the table controller.
protocol SearchTableControllerInterface: class, UITableViewDataSource, UITableViewDelegate {
	/**
	 Assigns the data model and reloads the table view.

	 - parameter model: The data model specifying the display.
	 */
	func setData(model: SearchDisplayModel.UpdateDisplay)

	/**
	 Updates the size and table view's content inset accordingly to the table view's size so the footer follows the last cell.
	 Needs to be called when the table view's size changes, e.g. in the call of `viewDidLayoutSubviews` of the `UIViewController`.
	 */
	func updateFooterSize()
}
