import UIKit

class ReminderTableController: NSObject {
	// MARK: - Properties

	/// The table view this controller manages.
	private let tableView: UITableView

	/// A reference to the logic to inform about cell actions.
	private weak var logic: ReminderLogicInterface?

	/// The model applied for display the content.
	private var displayModel: ReminderDisplayModel.UpdateDisplay?

	// MARK: - Init

	/**
	 Sets up the controller with needed references.

	 - parameter tableView: The reference to the table view this controller should manage.
	 - parameter logic: The logic which becomes the delegate to inform about cell actions. Will not be retained.
	 */
	init(tableView: UITableView, logic: ReminderLogicInterface) {
		self.tableView = tableView
		self.logic = logic
		super.init()

		// Table view
		tableView.delegate = self
		tableView.dataSource = self
		tableView.separatorStyle = .none
		tableView.backgroundColor = .clear
		tableView.isOpaque = false
		tableView.estimatedRowHeight = Const.Size.cellEstimatedDefaultHeight
		tableView.rowHeight = UITableView.automaticDimension
		tableView.indicatorStyle = .white

		// Register cells
		tableView.register(NavigationViewCell.self)
		tableView.register(ReminderCheckboxCell.self)
		tableView.register(ReminderPickerCell.self)
	}

	// MARK: - Table content

	/// The raw list of entries for the table view without any display states applied for cells.
	private var rawData = [
		ReminderTableControllerRawEntry()
	]

	/// The data representation for the table view.
	private var tableData = [ReminderTableData]()

	/**
	 Creates the data for the table view by mapping the `rawData` with the given display model.
	 Does not reload the table view itself.

	 - parameter model: The model to apply for displaying the content.
	 */
	private func createTableData(model: ReminderDisplayModel.UpdateDisplay) {
		// Clear data.
		tableData = [ReminderTableData]()

		// Add the navigation view as first cell on large style.
		if model.largeStyle {
			let navigationViewCellModel = NavigationViewCellModel(
				title: R.string.reminder.title(),
				color: Const.Color.white,
				largeStyle: true,
				separatorVisible: true,
				leftButtonVisible: true,
				leftButtonType: .back,
				rightButtonVisible: false,
				rightButtonType: .speaker,
				delegate: self
			)
			tableData.append(.navigation(navigationViewCellModel))
		}

		// Add the content cells.
		tableData.append(.checkbox)
		tableData.append(.picker)
	}
}

// MARK: - ReminderTableControllerInterface

extension ReminderTableController: ReminderTableControllerInterface {
	func setData(model: ReminderDisplayModel.UpdateDisplay) {
		displayModel = model
		createTableData(model: model)
		tableView.reloadData()
		tableView.contentOffset = .zero

		// Update cell selection for the checkbox cell.
		let entryIndex = tableData.index { entry -> Bool in
			switch entry {
			case .checkbox:
				return true
			default:
				return false
			}
		}
		guard let row = entryIndex else { fatalError("Checkbox entry not found") }
		let indexPath = IndexPath(row: row, section: 0)
		if model.checkboxChecked {
			tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
		} else {
			tableView.deselectRow(at: indexPath, animated: false)
		}
	}
}

// MARK: - UITableViewDataSource

extension ReminderTableController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tableData.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let data = tableData[indexPath.row]
		switch data {
		case let .navigation(model):
			return navigationViewCell(model: model)
		case .checkbox:
			return checkboxCell()
		case .picker:
			return pickerCell()
		}
	}

	// MARK: - Cells

	private func navigationViewCell(model: NavigationViewCellModel) -> NavigationViewCell {
		guard let cell = tableView.dequeueReusableCell(for: NavigationViewCell.self) else {
			fatalError("No cell available")
		}
		cell.setup(model: model)
		return cell
	}

	private func checkboxCell() -> ReminderCheckboxCell {
		guard let cell = tableView.dequeueReusableCell(for: ReminderCheckboxCell.self) else {
			fatalError("No cell available")
		}
		guard let displayModel = displayModel else { fatalError() }

		let cellModel = ReminderCheckboxCellModel(largeStyle: displayModel.largeStyle)
		cell.setup(model: cellModel)
		return cell
	}

	private func pickerCell() -> ReminderPickerCell {
		guard let cell = tableView.dequeueReusableCell(for: ReminderPickerCell.self) else {
			fatalError("No cell available")
		}
		guard let displayModel = displayModel else { fatalError() }

		let cellModel = ReminderPickerCellModel(largeStyle: displayModel.largeStyle, value: displayModel.pickerValue, delegate: self)
		cell.setup(model: cellModel)
		return cell
	}
}

// MARK: - UITableViewDelegate

extension ReminderTableController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		let data = tableData[indexPath.row]
		switch data {
		case .checkbox:
			return indexPath
		default:
			return nil
		}
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let data = tableData[indexPath.row]
		switch data {
		case .checkbox:
			logic?.toggleCheckbox()
		default:
			tableView.deselectRow(at: indexPath, animated: true)
			fatalError("Cell shouldn't be selectable")
		}
	}
}

// MARK: - NavigationViewCellDelegate

extension ReminderTableController: NavigationViewCellDelegate {
	func leftButtonPressed(onNavigationViewCell navigationViewCell: NavigationViewCell) {
		logic?.backButtonPressed()
	}

	func rightButtonPressed(onNavigationViewCell navigationViewCell: NavigationViewCell) {}
}

// MARK: - ReminderPickerCellDelegate

extension ReminderTableController: ReminderPickerCellDelegate {
	func pickerValueChanged(onReminderPickerCell reminderPickerCell: ReminderPickerCell, newValue: Int) {
		logic?.timePickerChanged(newValue: newValue)
	}
}
