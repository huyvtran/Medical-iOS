import UIKit

/// The public interface for the table controller.
protocol ReminderTableControllerInterface: class, UITableViewDataSource, UITableViewDelegate {
	/**
	 Assigns the data model and reloads the table view.

	 - parameter model: The data model specifying the display.
	 */
	func setData(model: ReminderDisplayModel.UpdateDisplay)
}
