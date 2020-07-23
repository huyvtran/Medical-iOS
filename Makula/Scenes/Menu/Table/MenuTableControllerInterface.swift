import UIKit

/// The public interface for the table controller.
protocol MenuTableControllerInterface: class, UITableViewDataSource, UITableViewDelegate {
	/**
	 Assigns the data model and reloads the table view.

	 Provides the speech data to the logic.

	 - parameter model: The data model specifying the display.
	 */
	func setData(model: MenuDisplayModel.UpdateDisplay)

	/**
	 Scrolls to the first cell.
	 */
	func scrollToTop()

	/**
	 Highlights / de-highlights the cell for a the given identifier.

	 - parameter indexPath: The cell's index path to modify.
	 - parameter highlight: Whether the cell should get highlighted (`true`) or de-highlighted (`false`).
	 */
	func setHighlight(indexPath: IndexPath, highlight: Bool)

	/**
	 Updates the size and table view's content inset accordingly to the table view's size so the footer follows the last cell.
	 Needs to be called when the table view's size changes, e.g. in the call of `viewDidLayoutSubviews` of the `UIViewController`.
	 */
	func updateFooterSize()
}
