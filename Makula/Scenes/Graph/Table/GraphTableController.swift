import UIKit

class GraphTableController: NSObject {
	// MARK: - Properties

	/// The table view this controller manages.
	private let tableView: UITableView

	/// A reference to the logic to inform about cell actions.
	private weak var logic: GraphLogicInterface?

	/// The model applied for display the content.
	private var displayModel: GraphDisplayModel.UpdateDisplay?

	// MARK: - Init

	/**
	 Sets up the controller with needed references.

	 - parameter tableView: The reference to the table view this controller should manage.
	 - parameter logic: The logic which becomes the delegate to inform about cell actions. Will not be retained.
	 */
	init(tableView: UITableView, logic: GraphLogicInterface) {
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
		tableView.register(StaticTextCell.self)
		tableView.register(SplitCell.self)
		tableView.register(GraphCell.self)
	}

	// MARK: - Table content

	/// The data representation for the table view.
	private var tableData = [GraphTableData]()

	/**
	 Creates the data for the table view by mapping the `rawData` with the given display model.
	 Does not reload the table view itself.

	 - parameter model: The model to apply for displaying the content.
	 */
	private func createTableData(model: GraphDisplayModel.UpdateDisplay) {
		// Clear data.
		tableData = [GraphTableData]()

		// Add the navigation view as first cell on large style.
		if model.largeStyle {
			tableData.append(.navigation)
		}

		// Add table cells.
		tableData.append(.eye)
		tableData.append(.date)
		tableData.append(.graph)
	}
}

// MARK: - GraphTableControllerInterface

extension GraphTableController: GraphTableControllerInterface {
	func setData(model: GraphDisplayModel.UpdateDisplay) {
		displayModel = model
		createTableData(model: model)

		// Bring the content to the top and reload the table next frame.
		tableView.contentOffset = .zero
		DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
			guard let strongSelf = self else { return }
			strongSelf.tableView.reloadData()
		}
	}
}

// MARK: - UITableViewDataSource

extension GraphTableController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tableData.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let data = tableData[indexPath.row]
		switch data {
		case .navigation:
			return navigationViewCell()
		case .eye:
			return eyeTitleCell()
		case .date:
			return dateTitleCell()
		case .graph:
			return graphCell()
		}
	}

	// MARK: - Cells

	private func navigationViewCell() -> NavigationViewCell {
		guard let cell = tableView.dequeueReusableCell(for: NavigationViewCell.self) else { fatalError() }

		// Prepare cell.
		let cellModel = NavigationViewCellModel(
			title: R.string.graph.title(),
			color: Const.Color.white,
			largeStyle: true,
			separatorVisible: true,
			leftButtonVisible: true,
			leftButtonType: .back,
			rightButtonVisible: false,
			rightButtonType: .speaker,
			delegate: self
		)
		cell.setup(model: cellModel)
		return cell
	}

	private func eyeTitleCell() -> SplitCell {
		guard let cell = tableView.dequeueReusableCell(for: SplitCell.self) else { fatalError() }
		guard let displayModel = displayModel else { fatalError() }

		// Prepare cell.
		let cellModel = SplitCellModel(
			leftTitle: R.string.graph.headerCellLeftEye(),
			rightTitle: R.string.graph.headerCellRightEye(),
			speechText: nil,
			leftSelected: displayModel.eyeType == .left,
			rightSelected: displayModel.eyeType == .right,
			largeStyle: displayModel.largeStyle,
			disabled: false,
			backgroundColor: Const.Color.darkMain,
			separatorColor: Const.Color.lightMain,
			delegate: self
		)
		cell.setup(model: cellModel)
		return cell
	}

	private func dateTitleCell() -> StaticTextCell {
		guard let cell = tableView.dequeueReusableCell(for: StaticTextCell.self) else { fatalError() }
		guard let displayModel = displayModel else { fatalError() }

		// Get the cell's title.
		let cellTitle = R.string.graph.ivomDateCellTitle()

		// Prepare cell.
		let cellModel = StaticTextCellModel(
			accessibilityIdentifier: GraphTableData.date.rawValue,
			title: cellTitle,
			speechTitle: nil,
			largeFont: displayModel.largeStyle,
			defaultColor: Const.Color.magenta,
			highlightColor: nil,
			backgroundColor: Const.Color.darkMain,
			separatorVisible: true,
			separatorDefaultColor: Const.Color.lightMain,
			separatorHighlightColor: nil,
			disabled: true,
			centeredText: true
		)
		cell.setup(model: cellModel)
		return cell
	}

	private func graphCell() -> GraphCell {
		guard let cell = tableView.dequeueReusableCell(for: GraphCell.self) else { fatalError() }
		guard let displayModel = displayModel else { fatalError() }

		// Prepare cell.
		let cellModel = GraphCellModel(
			largeStyle: displayModel.largeStyle,
			ivomDate: displayModel.ivomDate,
			nhdModels: displayModel.nhdModels,
			visusModels: displayModel.visusModels,
			eyeType: displayModel.eyeType
		)
		cell.setup(model: cellModel)
		return cell
	}
}

// MARK: - UITableViewDelegate

extension GraphTableController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		return nil
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
	}
}

// MARK: - NavigationViewCellDelegate

extension GraphTableController: NavigationViewCellDelegate {
	func leftButtonPressed(onNavigationViewCell navigationViewCell: NavigationViewCell) {
		logic?.backButtonPressed()
	}

	func rightButtonPressed(onNavigationViewCell navigationViewCell: NavigationViewCell) {
		fatalError()
	}
}

// MARK: - SplitCellDelegate

extension GraphTableController: SplitCellDelegate {
	func leftButtonPressed(onSplitCell splitCell: SplitCell) {
		logic?.leftEyeSelected()
	}

	func rightButtonPressed(onSplitCell splitCell: SplitCell) {
		logic?.rightEyeSelected()
	}
}
