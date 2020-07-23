import UIKit

class VisusNhdInputTableController: NSObject {
	// MARK: - Properties

	/// The table view this controller manages.
	private let tableView: UITableView

	/// A reference to the logic to inform about cell actions.
	private weak var logic: VisusNhdInputLogicInterface?

	/// The model applied for display the content.
	private var displayModel: VisusNhdInputDisplayModel.UpdateDisplay?

	// MARK: - Init

	/**
	 Sets up the controller with needed references.

	 - parameter tableView: The reference to the table view this controller should manage.
	 - parameter logic: The logic which becomes the delegate to inform about cell actions. Will not be retained.
	 */
	init(tableView: UITableView, logic: VisusNhdInputLogicInterface) {
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
		tableView.register(SplitCell.self)
		tableView.register(VisusNhdInputPickerCell.self)
	}

	// MARK: - Table content

	/// The data representation for the table view.
	private var tableData = [VisusNhdInputTableData]()

	/**
	 Creates the data for the table view with the given display model.
	 Does not reload the table view itself.

	 - parameter model: The model to apply for displaying the content.
	 */
	private func createTableData(model: VisusNhdInputDisplayModel.UpdateDisplay) {
		// Clear data.
		tableData = [VisusNhdInputTableData]()

		// Add the navigation view as first cell on large style.
		if model.largeStyle {
			let navigationViewCellModel = NavigationViewCellModel(
				title: model.sceneType.visusNhdInputTitleString(),
				color: Const.Color.white,
				largeStyle: true,
				separatorVisible: true,
				leftButtonVisible: true,
				leftButtonType: .back,
				rightButtonVisible: true,
				rightButtonType: .navInfo,
				delegate: self
			)
			tableData.append(.navigation(navigationViewCellModel))
		}

		// Add 2 split cells for the titles and the values.
		tableData.append(VisusNhdInputTableData.split(
			SplitCellModel(
				leftTitle: R.string.visusNhdInput.cellTitleLeft(),
				rightTitle: R.string.visusNhdInput.cellTitleRight(),
				speechText: nil,
				leftSelected: model.leftSelected,
				rightSelected: model.rightSelected,
				largeStyle: model.largeStyle,
				disabled: false,
				backgroundColor: Const.Color.darkMain,
				separatorColor: Const.Color.lightMain,
				delegate: self
			)
		))
		tableData.append(VisusNhdInputTableData.split(
			SplitCellModel(
				leftTitle: model.sceneType.valueOutput(value: model.leftValue),
				rightTitle: model.sceneType.valueOutput(value: model.rightValue),
				speechText: nil,
				leftSelected: model.leftSelected,
				rightSelected: model.rightSelected,
				largeStyle: model.largeStyle,
				disabled: false,
				backgroundColor: Const.Color.darkMain,
				separatorColor: Const.Color.lightMain,
				delegate: self
			)
		))

		// Add the picker cell.
		if model.leftSelected, let value = model.leftValue {
			tableData.append(VisusNhdInputTableData.picker(
				VisusNhdInputPickerCellModel(
					largeStyle: model.largeStyle,
					type: model.sceneType,
					value: value,
					delegate: self
				)
			))
		} else if model.rightSelected, let value = model.rightValue {
			tableData.append(VisusNhdInputTableData.picker(
				VisusNhdInputPickerCellModel(
					largeStyle: model.largeStyle,
					type: model.sceneType,
					value: value,
					delegate: self
				)
			))
		}
	}
}

// MARK: - VisusNhdInputTableControllerInterface

extension VisusNhdInputTableController: VisusNhdInputTableControllerInterface {
	func setData(model: VisusNhdInputDisplayModel.UpdateDisplay) {
		displayModel = model
		createTableData(model: model)

		// Bring the content to the top and reload the table next frame.
		tableView.contentOffset = .zero
		DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
			self?.tableView.reloadData()
		}
	}

	func updateValueTitle(model: VisusNhdInputDisplayModel.UpdateValueTitle) {
		guard let displayModel = displayModel else { fatalError() }

		// Update table data.
		let indexPath = IndexPath(row: displayModel.largeStyle ? 2 : 1, section: 0)
		let data = tableData[indexPath.row]
		guard case let .split(oldCellModel) = data else { fatalError() }
		let newCellModel = SplitCellModel(
			leftTitle: displayModel.sceneType.valueOutput(value: model.leftValue),
			rightTitle: displayModel.sceneType.valueOutput(value: model.rightValue),
			speechText: nil,
			leftSelected: oldCellModel.leftSelected,
			rightSelected: oldCellModel.rightSelected,
			largeStyle: oldCellModel.largeStyle,
			disabled: false,
			backgroundColor: Const.Color.darkMain,
			separatorColor: Const.Color.lightMain,
			delegate: oldCellModel.delegate
		)
		tableData[indexPath.row] = .split(newCellModel)

		// Update cell.
		guard let cell = tableView.cellForRow(at: indexPath) as? SplitCell else { return }
		cell.setup(model: newCellModel)
	}
}

// MARK: - UITableViewDataSource

extension VisusNhdInputTableController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tableData.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let data = tableData[indexPath.row]
		switch data {
		case let .navigation(model):
			return navigationViewCell(model: model)
		case let .split(model):
			return splitCell(model: model)
		case let .picker(model):
			return pickerCell(model: model)
		}
	}

	// MARK: - Cells

	private func navigationViewCell(model: NavigationViewCellModel) -> NavigationViewCell {
		guard let cell = tableView.dequeueReusableCell(for: NavigationViewCell.self) else { fatalError() }
		cell.setup(model: model)
		return cell
	}

	private func splitCell(model: SplitCellModel) -> SplitCell {
		guard let cell = tableView.dequeueReusableCell(for: SplitCell.self) else { fatalError() }
		cell.setup(model: model)
		return cell
	}

	private func pickerCell(model: VisusNhdInputPickerCellModel) -> VisusNhdInputPickerCell {
		guard let cell = tableView.dequeueReusableCell(for: VisusNhdInputPickerCell.self) else { fatalError() }
		cell.setup(model: model)
		return cell
	}
}

// MARK: - UITableViewDelegate

extension VisusNhdInputTableController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		let data = tableData[indexPath.row]
		switch data {
		default:
			return nil
		}
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let data = tableData[indexPath.row]
		switch data {
		default:
			fatalError()
		}
	}
}

// MARK: - NavigationViewCellDelegate

extension VisusNhdInputTableController: NavigationViewCellDelegate {
	func leftButtonPressed(onNavigationViewCell navigationViewCell: NavigationViewCell) {
		logic?.backButtonPressed()
	}

	func rightButtonPressed(onNavigationViewCell navigationViewCell: NavigationViewCell) {
		logic?.infoButtonPressed()
	}
}

// MARK: - SplitCellDelegate

extension VisusNhdInputTableController: SplitCellDelegate {
	func leftButtonPressed(onSplitCell splitCell: SplitCell) {
		logic?.leftEyeSelected()
	}

	func rightButtonPressed(onSplitCell splitCell: SplitCell) {
		logic?.rightEyeSelected()
	}
}

// MARK: - VisusNhdInputPickerCellDelegate

extension VisusNhdInputTableController: VisusNhdInputPickerCellDelegate {
	func pickerValueChanged(onVisusNhdInputPickerCell visusNhdInputPickerCell: VisusNhdInputPickerCell, newValue: Float) {
		logic?.valueChanged(newValue: newValue)
	}
}
