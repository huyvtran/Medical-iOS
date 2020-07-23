import RealmSwift
import UIKit

class AmslertestTableController: NSObject {
	// MARK: - Properties

	/// The table view this controller manages.
	private let tableView: UITableView

	/// A reference to the logic to inform about cell actions.
	private weak var logic: AmslertestLogicInterface?

	/// The model applied for display the content.
	private var displayModel: AmslertestDisplayModel.UpdateDisplay?

	// MARK: - Init

	/**
	 Sets up the controller with needed references.

	 - parameter tableView: The reference to the table view this controller should manage.
	 - parameter logic: The logic which becomes the delegate to inform about cell actions. Will not be retained.
	 */
	init(tableView: UITableView, logic: AmslertestLogicInterface) {
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
		tableView.register(AmslertestImageCell.self)
		tableView.register(StaticTextCell.self)
		tableView.register(SplitCell.self)
		tableView.register(SplitRadioCell.self)
		tableView.register(NavigationViewCell.self)
	}

	// MARK: - Table content

	/// The data representation for the table view.
	private var tableData = [AmslertestTableData]()

	/// The order of the progress type cells in the table view.
	private let progressTypeOrder: [AmslertestProgressType] = [.equal, .better, .worse]

	/**
	 Creates the data for the table view bwith the given display model.
	 Does not reload the table view itself.

	 - parameter model: The model to apply for displaying the content.
	 */
	private func createTableData(model: AmslertestDisplayModel.UpdateDisplay) {
		// Clear data.
		tableData = [AmslertestTableData]()

		// Add the navigation view as first cell on large style.
		if model.largeStyle {
			tableData.append(.navigation)
		}

		// Add an Image cell showing a grid image.
		tableData.append(.gridImage)
		// Add a text cell for the title.
		tableData.append(.titleLabel)
		// Add a split cell for the titles.
		tableData.append(.split)
		// Add the split radio button cells for the progress types.
		for progressType in progressTypeOrder {
			tableData.append(.splitRadio(progressType))
		}
	}

	// MARK: - Realm

	/// The notification token for observing the amslertest model.
	private var amslertestModelToken: RealmSwift.NotificationToken?

	/// The block invoced when any changes to the amslertest results applies.
	private lazy var amslertestModelNotificationBlock: (ObjectChange) -> Void = { [weak self] changes in
		guard let strongSelf = self else { return }
		let tableView = strongSelf.tableView
		guard let displayModel = strongSelf.displayModel else { return }
		let firstProgressTypeCellRowIndex = displayModel.largeStyle ? 4 : 3

		switch changes {
		case let .change(properties):
			for (index, progressType) in strongSelf.progressTypeOrder.enumerated() {
				let indexPath = IndexPath(row: firstProgressTypeCellRowIndex + index, section: 0)
				if let cell = tableView.cellForRow(at: indexPath) as? SplitRadioCell {
					let cellModel = SplitRadioCellModel(
						indexPath: indexPath,
						title: progressType.titleText(),
						leftSelected: displayModel.amslertestModel?.progressLeft == progressType,
						rightSelected: displayModel.amslertestModel?.progressRight == progressType,
						largeStyle: displayModel.largeStyle,
						disabled: false,
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

// MARK: - AmslertestTableControllerInterface

extension AmslertestTableController: AmslertestTableControllerInterface {
	func setData(model: AmslertestDisplayModel.UpdateDisplay) {
		displayModel = model
		createTableData(model: model)
		amslertestModelToken = model.amslertestModel?.observe(amslertestModelNotificationBlock)

		// Bring the content to the top and reload the table next frame.
		tableView.contentOffset = .zero
		DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
			guard let strongSelf = self else { return }
			strongSelf.tableView.reloadData()
		}
	}
}

// MARK: - UITableViewDataSource

extension AmslertestTableController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tableData.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let data = tableData[indexPath.row]
		switch data {
		case .navigation:
			return navigationViewCell()
		case .gridImage:
			return gridImageCell()
		case .titleLabel:
			return textCell()
		case .split:
			return splitCell()
		case let .splitRadio(progressType):
			return splitRadioCell(progressType: progressType, indexPath: indexPath)
		}
	}

	// MARK: - Cells

	private func gridImageCell() -> AmslertestImageCell {
		guard let cell = tableView.dequeueReusableCell(for: AmslertestImageCell.self) else { fatalError() }

		let cellModel = AmslertestImageCellModel()
		cell.setup(model: cellModel)
		return cell
	}

	private func textCell() -> StaticTextCell {
		guard let cell = tableView.dequeueReusableCell(for: StaticTextCell.self) else { fatalError() }
		guard let displayModel = displayModel else { fatalError() }

		let cellModel = StaticTextCellModel(
			accessibilityIdentifier: AmslertestTableData.titleLabel.accessibilityIdentifier,
			title: R.string.amslertest.textCellTitle(),
			speechTitle: nil,
			largeFont: displayModel.largeStyle,
			defaultColor: Const.Color.lightMain,
			highlightColor: nil,
			backgroundColor: Const.Color.darkMain,
			separatorVisible: true,
			separatorDefaultColor: nil,
			separatorHighlightColor: nil,
			disabled: true,
			centeredText: false
		)
		cell.setup(model: cellModel)
		return cell
	}

	private func splitCell() -> SplitCell {
		guard let cell = tableView.dequeueReusableCell(for: SplitCell.self) else { fatalError() }
		guard let displayModel = displayModel else { fatalError() }

		let cellModel = SplitCellModel(
			leftTitle: R.string.amslertest.splitCellTitleLeft(),
			rightTitle: R.string.amslertest.splitCellTitleRight(),
			speechText: nil,
			leftSelected: false,
			rightSelected: false,
			largeStyle: displayModel.largeStyle,
			disabled: true,
			backgroundColor: Const.Color.darkMain,
			separatorColor: Const.Color.lightMain,
			delegate: nil
		)
		cell.setup(model: cellModel)
		return cell
	}

	private func splitRadioCell(progressType: AmslertestProgressType, indexPath: IndexPath) -> SplitRadioCell {
		guard let cell = tableView.dequeueReusableCell(for: SplitRadioCell.self) else { fatalError() }
		guard let displayModel = displayModel else { fatalError() }

		let cellModel = SplitRadioCellModel(
			indexPath: indexPath,
			title: progressType.titleText(),
			leftSelected: displayModel.amslertestModel?.progressLeft == progressType,
			rightSelected: displayModel.amslertestModel?.progressRight == progressType,
			largeStyle: displayModel.largeStyle,
			disabled: false,
			delegate: self
		)
		cell.setup(model: cellModel)
		return cell
	}

	private func navigationViewCell() -> NavigationViewCell {
		guard let cell = tableView.dequeueReusableCell(for: NavigationViewCell.self) else { fatalError() }
		let cellModel = NavigationViewCellModel(
			title: R.string.amslertest.title(),
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

extension AmslertestTableController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		return nil
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
	}
}

// MARK: - NavigationViewCellDelegate

extension AmslertestTableController: NavigationViewCellDelegate {
	func leftButtonPressed(onNavigationViewCell navigationViewCell: NavigationViewCell) {
		logic?.backButtonPressed()
	}

	func rightButtonPressed(onNavigationViewCell navigationViewCell: NavigationViewCell) {
		logic?.infoButtonPressed()
	}
}

// MARK: - SplitRadioCellDelegate

extension AmslertestTableController: SplitRadioCellDelegate {
	func leftButtonPressed(onSplitRadioCell splitRadioCell: SplitRadioCell, indexPath: IndexPath) {
		let data = tableData[indexPath.row]
		guard case let .splitRadio(progressType) = data else { fatalError() }
		guard let dataModelManager = displayModel?.dataModelManager else { fatalError() }

		if let amslertestModel = displayModel?.amslertestModel {
			let newValue = amslertestModel.progressLeft == progressType ? nil : progressType
			if !dataModelManager.updateAmslertestModel(amslertestModel, progressLeft: newValue) {
				logic?.databaseWriteError()
			}
		}
	}

	func rightButtonPressed(onSplitRadioCell splitRadioCell: SplitRadioCell, indexPath: IndexPath) {
		let data = tableData[indexPath.row]
		guard case let .splitRadio(progressType) = data else { fatalError() }
		guard let dataModelManager = displayModel?.dataModelManager else { fatalError() }

		if let amslertestModel = displayModel?.amslertestModel {
			let newValue = amslertestModel.progressRight == progressType ? nil : progressType
			if !dataModelManager.updateAmslertestModel(amslertestModel, progressRight: newValue) {
				logic?.databaseWriteError()
			}
		}
	}
}
