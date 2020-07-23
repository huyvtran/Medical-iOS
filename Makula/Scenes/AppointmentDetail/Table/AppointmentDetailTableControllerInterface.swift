import UIKit

/// The public interface for the table controller.
protocol AppointmentDetailTableControllerInterface: class, UITableViewDataSource, UITableViewDelegate {
	/**
	 Assigns the data model and reloads the table view.

	 - parameter model: The data model specifying the display.
	 */
	func setData(model: AppointmentDetailDisplayModel.UpdateDisplay)

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
}
