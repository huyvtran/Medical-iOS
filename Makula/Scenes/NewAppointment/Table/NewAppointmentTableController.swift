import UIKit

class NewAppointmentTableController: NSObject {
	// MARK: - Properties

	/// The table view this controller manages.
	private let tableView: UITableView

	/// A reference to the logic to inform about cell actions.
	private weak var logic: NewAppointmentLogicInterface?

	/// The model applied for display the content.
	private var displayModel: NewAppointmentDisplayModel.UpdateDisplay?

	// MARK: - Init

	/**
	 Sets up the controller with needed references.

	 - parameter tableView: The reference to the table view this controller should manage.
	 - parameter logic: The logic which becomes the delegate to inform about cell actions. Will not be retained.
	 */
	init(tableView: UITableView, logic: NewAppointmentLogicInterface) {
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
		tableView.register(StaticTextCell.self)
		tableView.register(NavigationViewCell.self)
	}

	// MARK: - Table content

	/// The raw list of entries for the table view without any display states applied for cells.
	private var rawData = [
		NewAppointmentTableControllerRawEntry(type: .treatment),
		NewAppointmentTableControllerRawEntry(type: .aftercare),
		NewAppointmentTableControllerRawEntry(type: .octCheck),
		NewAppointmentTableControllerRawEntry(type: .other)
	]

	/// The data representation for the table view.
	private var tableData = [NewAppointmentTableData]()

	/**
	 Creates the data for the table view by mapping the `rawData` with the given display model.
	 Does not reload the table view itself.

	 - parameter model: The model to apply for displaying the content.
	 */
	private func createTableData(model: NewAppointmentDisplayModel.UpdateDisplay) {
		// Clear data.
		tableData = [NewAppointmentTableData]()

		// Add the navigation view as first cell on large style.
		if model.largeStyle {
			let navigationViewCellModel = NavigationViewCellModel(
				title: R.string.newAppointment.title(),
				color: Const.Color.white,
				largeStyle: true,
				separatorVisible: true,
				leftButtonVisible: true,
				leftButtonType: .back,
				rightButtonVisible: true,
				rightButtonType: .speaker,
				delegate: self
			)
			tableData.append(.navigation(navigationViewCellModel))
		}

		// Make raw data as cells.
		let mainCells = rawData.map { data -> NewAppointmentTableData in
			guard let identifier = AppointmentCellIdentifier(appointmentType: data.type) else { fatalError() }
			return NewAppointmentTableData.main(
				StaticTextCellModel(
					accessibilityIdentifier: identifier.rawValue,
					title: data.type.nameString(),
					speechTitle: nil,
					largeFont: model.largeStyle,
					defaultColor: data.type.defaultColor(),
					highlightColor: data.type.highlightColor(),
					backgroundColor: Const.Color.darkMain,
					separatorVisible: true,
					separatorDefaultColor: data.type.defaultColor(),
					separatorHighlightColor: nil,
					disabled: false,
					centeredText: false
				),
				identifier
			)
		}
		tableData += mainCells

		// Use the main cells to provide the speech data to the logic.
		var rowIndex = model.largeStyle ? 1 : 0
		let speechData = mainCells.map { model -> SpeechData in
			guard case let .main(_, cellIdentifier) = model else { fatalError() }
			let indexPath = IndexPath(row: rowIndex, section: 0)
			rowIndex += 1
			return SpeechData(text: cellIdentifier.speechText(), indexPath: indexPath)
		}
		logic?.setSpeechData(data: speechData)
	}
}

// MARK: - NewAppointmentTableControllerInterface

extension NewAppointmentTableController: NewAppointmentTableControllerInterface {
	func setData(model: NewAppointmentDisplayModel.UpdateDisplay) {
		displayModel = model
		createTableData(model: model)

		// Bring the content to the top and reload the table next frame.
		tableView.contentOffset = .zero
		DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
			self?.tableView.reloadData()
		}
	}

	func scrollToTop() {
		tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
	}

	func setHighlight(indexPath: IndexPath, highlight: Bool) {
		// Update cell's state.
		if highlight {
			tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
		} else {
			tableView.deselectRow(at: indexPath, animated: true)
		}
	}
}

// MARK: - UITableViewDataSource

extension NewAppointmentTableController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tableData.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let data = tableData[indexPath.row]
		switch data {
		case let .main(model, _):
			return mainCell(model: model)
		case let .navigation(model):
			return navigationViewCell(model: model)
		}
	}

	// MARK: - Cells

	private func mainCell(model: StaticTextCellModel) -> StaticTextCell {
		guard let cell = tableView.dequeueReusableCell(for: StaticTextCell.self) else {
			fatalError("No cell available")
		}
		cell.setup(model: model)
		return cell
	}

	private func navigationViewCell(model: NavigationViewCellModel) -> NavigationViewCell {
		guard let cell = tableView.dequeueReusableCell(for: NavigationViewCell.self) else {
			fatalError("No cell available")
		}
		cell.setup(model: model)
		return cell
	}
}

// MARK: - UITableViewDelegate

extension NewAppointmentTableController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		let data = tableData[indexPath.row]
		switch data {
		case .main:
			return indexPath
		default:
			return nil
		}
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

		let data = tableData[indexPath.row]
		switch data {
		case .main:
			logic?.routeToDatePicker(appointment: rawData[indexPath.row].type)
		default:
			fatalError("Cell shouldn't be selectable")
		}
	}
}

// MARK: - NavigationViewCellDelegate

extension NewAppointmentTableController: NavigationViewCellDelegate {
	func leftButtonPressed(onNavigationViewCell navigationViewCell: NavigationViewCell) {
		logic?.backButtonPressed()
	}

	func rightButtonPressed(onNavigationViewCell navigationViewCell: NavigationViewCell) {
		logic?.speakButtonPressed()
	}
}
