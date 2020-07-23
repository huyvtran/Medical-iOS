import RealmSwift
import UIKit

class ReadingTestTableController: NSObject {
	// MARK: - Properties

	/// The table view this controller manages.
	private let tableView: UITableView

	/// A reference to the logic to inform about cell actions.
	private weak var logic: ReadingTestLogicInterface?

	/// The model applied for display the content.
	private var displayModel: ReadingTestDisplayModel.UpdateDisplay?

	// MARK: - Init

	/**
	 Sets up the controller with needed references.

	 - parameter tableView: The reference to the table view this controller should manage.
	 - parameter logic: The logic which becomes the delegate to inform about cell actions. Will not be retained.
	 */
	init(tableView: UITableView, logic: ReadingTestLogicInterface) {
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
		tableView.register(SplitCell.self)
		tableView.register(ReadingTestMainCell.self)
		tableView.register(NavigationViewCell.self)
	}

	// MARK: - Table content

	/// The data representation for the table view.
	private var tableData = [ReadingTestTableData]()

	/// The list of the magnitude type cells in the table view.
	private let magnitudeTypes: [ReadingTestMagnitudeType] = [
		.big, .large, .medium, .small, .little, .tiny
	]

	/**
	 Creates the data for the table view by mapping the `rawData` with the given display model.
	 Does not reload the table view itself.

	 - parameter model: The model to apply for displaying the content.
	 */
	private func createTableData(model: ReadingTestDisplayModel.UpdateDisplay) {
		// Clear data.
		tableData = [ReadingTestTableData]()

		// Add the navigation view as first cell on large style.
		if model.largeStyle {
			tableData.append(.navigation)
		}

		// Add a split cell for the titles.
		tableData.append(.split)
		// Add the main cells for the magnitude types.
		for magnitudeType in magnitudeTypes {
			tableData.append(.main(magnitudeType))
		}
	}

	// MARK: - Realm

	/// The notification token for observing the reading test model.
	private var readingTestModelToken: RealmSwift.NotificationToken?

	/// The block invoced when any changes to the reading test results applies.
	private lazy var readingTestModelNotificationBlock: (ObjectChange) -> Void = { [weak self] changes in
		guard let strongSelf = self else { return }
		let tableView = strongSelf.tableView
		guard let displayModel = strongSelf.displayModel else { return }
		let firstMagnitudeTypeCellRowIndex = displayModel.largeStyle ? 2 : 1

		switch changes {
		case let .change(properties):
			for (index, magnitudeType) in strongSelf.magnitudeTypes.enumerated() {
				let indexPath = IndexPath(row: firstMagnitudeTypeCellRowIndex + index, section: 0)
				if let cell = tableView.cellForRow(at: indexPath) as? ReadingTestMainCell {
					let cellModel = ReadingTestMainCellModel(
						indexPath: indexPath,
						magnitudeType: magnitudeType,
						content: magnitudeType.contentText(),
						leftSelected: displayModel.readingTestModel?.magnitudeLeft == magnitudeType,
						rightSelected: displayModel.readingTestModel?.magnitudeRight == magnitudeType,
						largeStyle: displayModel.largeStyle,
						delegate: self
					)
					cell.setup(model: cellModel)
				}
			}
		case .deleted:
			// Ignore deletion, which may happen when dismissing the scene.
			break
		case let .error(error):
			Log.warn("Realm error for amslertest model: \(error)")
			strongSelf.logic?.databaseWriteError()
		}
	}
}

// MARK: - ReadingTestTableControllerInterface

extension ReadingTestTableController: ReadingTestTableControllerInterface {
	func setData(model: ReadingTestDisplayModel.UpdateDisplay) {
		displayModel = model
		createTableData(model: model)
		readingTestModelToken = model.readingTestModel?.observe(readingTestModelNotificationBlock)

		// Bring the content to the top and reload the table next frame.
		tableView.contentOffset = .zero
		DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
			guard let strongSelf = self else { return }
			strongSelf.tableView.reloadData()
		}
	}
}

// MARK: - UITableViewDataSource

extension ReadingTestTableController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tableData.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let data = tableData[indexPath.row]
		switch data {
		case .navigation:
			return navigationViewCell()
		case .split:
			return splitCell()
		case let .main(magnitudeType):
			return mainCell(magnitudeType: magnitudeType, indexPath: indexPath)
		}
	}

	// MARK: - Cells

	private func splitCell() -> SplitCell {
		guard let cell = tableView.dequeueReusableCell(for: SplitCell.self) else { fatalError() }
		guard let displayModel = displayModel else { fatalError() }

		let cellModel = SplitCellModel(
			leftTitle: R.string.readingTest.splitCellTitleLeft(),
			rightTitle: R.string.readingTest.splitCellTitleRight(),
			speechText: nil,
			leftSelected: false,
			rightSelected: false,
			largeStyle: displayModel.largeStyle,
			disabled: true,
			backgroundColor: Const.Color.white,
			separatorColor: Const.Color.darkMain,
			delegate: nil
		)
		cell.setup(model: cellModel)
		return cell
	}

	private func mainCell(magnitudeType: ReadingTestMagnitudeType, indexPath: IndexPath) -> ReadingTestMainCell {
		guard let cell = tableView.dequeueReusableCell(for: ReadingTestMainCell.self) else { fatalError() }
		guard let displayModel = displayModel else { fatalError() }

		let cellModel = ReadingTestMainCellModel(
			indexPath: indexPath,
			magnitudeType: magnitudeType,
			content: magnitudeType.contentText(),
			leftSelected: displayModel.readingTestModel?.magnitudeLeft == magnitudeType,
			rightSelected: displayModel.readingTestModel?.magnitudeRight == magnitudeType,
			largeStyle: displayModel.largeStyle,
			delegate: self
		)
		cell.setup(model: cellModel)
		return cell
	}

	private func navigationViewCell() -> NavigationViewCell {
		guard let cell = tableView.dequeueReusableCell(for: NavigationViewCell.self) else {
			fatalError("No cell available")
		}
		let cellModel = NavigationViewCellModel(
			title: R.string.readingTest.title(),
			color: Const.Color.white,
			largeStyle: true,
			separatorVisible: false,
			leftButtonVisible: true,
			leftButtonType: .back,
			rightButtonVisible: true,
			rightButtonType: .navInfo,
			delegate: self
		)
		cell.setup(model: cellModel)
		return cell
	}
}

// MARK: - UITableViewDelegate

extension ReadingTestTableController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		return nil
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}

// MARK: - NavigationViewCellDelegate

extension ReadingTestTableController: NavigationViewCellDelegate {
	func leftButtonPressed(onNavigationViewCell navigationViewCell: NavigationViewCell) {
		logic?.backButtonPressed()
	}

	func rightButtonPressed(onNavigationViewCell navigationViewCell: NavigationViewCell) {
		logic?.infoButtonPressed()
	}
}

// MARK: - ReadingTestMainCellDelegate

extension ReadingTestTableController: ReadingTestMainCellDelegate {
	func leftButtonPressed(onMainCell mainCell: ReadingTestMainCell, indexPath: IndexPath) {
		let data = tableData[indexPath.row]
		guard case let .main(magnitudeType) = data else { fatalError() }
		guard let dataModelManager = displayModel?.dataModelManager else { fatalError() }

		if let readingTestModel = displayModel?.readingTestModel {
			let newValue = readingTestModel.magnitudeLeft == magnitudeType ? nil : magnitudeType
			if !dataModelManager.updateReadingTestModel(readingTestModel, magnitudeLeft: newValue) {
				logic?.databaseWriteError()
			}
		}
	}

	func rightButtonPressed(onMainCell mainCell: ReadingTestMainCell, indexPath: IndexPath) {
		let data = tableData[indexPath.row]
		guard case let .main(magnitudeType) = data else { fatalError() }
		guard let dataModelManager = displayModel?.dataModelManager else { fatalError() }

		if let readingTestModel = displayModel?.readingTestModel {
			let newValue = readingTestModel.magnitudeRight == magnitudeType ? nil : magnitudeType
			if !dataModelManager.updateReadingTestModel(readingTestModel, magnitudeRight: newValue) {
				logic?.databaseWriteError()
			}
		}
	}
}
