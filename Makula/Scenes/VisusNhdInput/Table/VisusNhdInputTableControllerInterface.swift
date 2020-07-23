import UIKit

/// The public interface for the table controller.
protocol VisusNhdInputTableControllerInterface: class, UITableViewDataSource, UITableViewDelegate {
	/**
	 Assigns the data model and reloads the table view.

	 - parameter model: The data model specifying the display.
	 */
	func setData(model: VisusNhdInputDisplayModel.UpdateDisplay)

	/**
	 Updates the value titles in the cell without reloading the whole table view.

	 - parameter model: The data to show.
	 */
	func updateValueTitle(model: VisusNhdInputDisplayModel.UpdateValueTitle)
}
