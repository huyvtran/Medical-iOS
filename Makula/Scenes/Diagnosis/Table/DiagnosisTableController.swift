import RealmSwift
import UIKit

class DiagnosisTableController: NSObject {
	// MARK: - Properties

	/// The table view this controller manages.
	private let tableView: UITableView

	/// A reference to the logic to inform about cell actions.
	private weak var logic: DiagnosisLogicInterface?

	/// The model applied for display the content.
	private var displayModel: DiagnosisDisplayModel.UpdateDisplay?

	/// The diagnosis models to display in the table.
	private var diagnosisModels: Results<DiagnosisModel>?

	// MARK: - Init

	/**
	 Sets up the controller with needed references.

	 - parameter tableView: The reference to the table view this controller should manage.
	 - parameter logic: The logic which becomes the delegate to inform about cell actions. Will not be retained.
	 */
	init(tableView: UITableView, logic: DiagnosisLogicInterface) {
		self.tableView = tableView
		self.logic = logic
		super.init()

		// Table view.
		tableView.delegate = self
		tableView.dataSource = self
		tableView.separatorStyle = .none
		tableView.backgroundColor = .clear
		tableView.isOpaque = false
		tableView.estimatedRowHeight = Const.Size.cellEstimatedDefaultHeight
		tableView.rowHeight = UITableView.automaticDimension
		tableView.indicatorStyle = .white
		tableView.allowsMultipleSelection = true

		// Register cells.
		tableView.register(DiagnosisMainCell.self)
		tableView.register(NavigationViewCell.self)
	}
}

// MARK: - DiagnosisTableControllerInterface

extension DiagnosisTableController: DiagnosisTableControllerInterface {
	func setData(model: DiagnosisDisplayModel.UpdateDisplay) {
		displayModel = model
		diagnosisModels = model.dataModelManager.getDiagnosisModels()

		// Bring the content to the top and reload the table next frame.
		tableView.contentOffset = .zero
		DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
			self?.tableView.reloadData()
			guard let models = self?.diagnosisModels else { return }

			var rowIndex = model.largeStyle ? 1 : 0
			var speechData = [SpeechData]()
			for model in models {
				guard let identifier = DiagnosisCellIdentifier(model.type) else { continue }
				let text = identifier.speechText()
				let indexPath = IndexPath(row: rowIndex, section: 0)
				let data = SpeechData(text: text, indexPath: indexPath)
				rowIndex += 1
				speechData.append(data)
			}
			self?.logic?.setSpeechData(data: speechData)
		}
	}

	func scrollToTop() {
		tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
	}

	func setHighlight(indexPath: IndexPath, highlight: Bool) {
		guard let cell = tableView.cellForRow(at: indexPath) as? DiagnosisMainCell else { return }

		// Update cell's state.
		tableView.scrollToRow(at: indexPath, at: .top, animated: true)
		cell.setSpeechHighlight(highlight)
	}
}

// MARK: - UITableViewDataSource

extension DiagnosisTableController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		guard let displayModel = displayModel else { return 0 }
		return displayModel.largeStyle ? 2 : 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let displayModel = displayModel else { return 0 }

		if displayModel.largeStyle && section == 0 {
			// Navigation view.
			return 1
		}

		// Content list.
		guard let diagnosisModels = diagnosisModels else { return 0 }
		return diagnosisModels.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch cellType(indexPath: indexPath) {
		case .navigation:
			return navigationViewCell()
		case .main:
			return mainCell(indexPath: indexPath)
		}
	}

	/**
	 Determines the cell type at a given index path taking the display model into count.

	 - parameter indexPath: The cell's index path.
	 - returns: The cell's type.
	 */
	private func cellType(indexPath: IndexPath) -> DiagnosisTableCellType {
		guard let displayModel = displayModel else { fatalError() }
		if displayModel.largeStyle && indexPath.section == 0 {
			return .navigation
		} else {
			return .main
		}
	}

	// MARK: - Cells

	private func navigationViewCell() -> NavigationViewCell {
		guard let cell = tableView.dequeueReusableCell(for: NavigationViewCell.self) else {
			fatalError("No cell available")
		}
		let model = NavigationViewCellModel(
			title: R.string.diagnosis.title(),
			color: Const.Color.white,
			largeStyle: true,
			separatorVisible: true,
			leftButtonVisible: true,
			leftButtonType: .back,
			rightButtonVisible: true,
			rightButtonType: .speaker,
			delegate: self
		)
		cell.setup(model: model)
		return cell
	}

	private func mainCell(indexPath: IndexPath) -> DiagnosisMainCell {
		guard let cell = tableView.dequeueReusableCell(for: DiagnosisMainCell.self) else {
			fatalError("No cell available")
		}
		guard let displayModel = displayModel else { fatalError() }
		guard let diagnosisModels = diagnosisModels else { fatalError() }

		// Setup cell with model.
		let diagnosisModel = diagnosisModels[indexPath.row]
		guard let identifier = DiagnosisCellIdentifier(diagnosisModel.type) else { fatalError() }
		let model = DiagnosisMainCellModel(
			accessibilityIdentifier: identifier.rawValue,
			rowIndex: indexPath.row,
			title: diagnosisModel.type.titleText(),
			subtitle: diagnosisModel.type.subTitleText(),
			largeStyle: displayModel.largeStyle,
			delegate: self
		)
		cell.setup(model: model)

		// Pre-select state, has to be told to the table view.
		if diagnosisModel.selected {
			tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
		}

		return cell
	}
}

// MARK: - UITableViewDelegate

extension DiagnosisTableController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		// Only the main content can be selected.
		switch cellType(indexPath: indexPath) {
		case .main:
			return indexPath
		default:
			return nil
		}
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		updateDiagnosisModel(indexPath: indexPath, selected: true)
	}

	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		updateDiagnosisModel(indexPath: indexPath, selected: false)
	}

	/**
	 Updates the `selected` state of a diagnosis model at a specific index path.

	 - parameter indexPath: The cell's index path representing the model.
	 - parameter selected: Set to `true` when the model gets selected, `false` when deselected.
	 */
	private func updateDiagnosisModel(indexPath: IndexPath, selected: Bool) {
		guard let logic = logic else { return }
		precondition(cellType(indexPath: indexPath) == .main)
		guard let displayModel = displayModel else { fatalError() }
		guard let diagnosisModels = diagnosisModels else { fatalError() }

		// Update model.
		let diagnosisModel = diagnosisModels[indexPath.row]
		if !displayModel.dataModelManager.setDiagnosisModel(diagnosisModel, selected: selected) {
			// Notify logic about error.
			logic.databaseWriteError()
		}
	}
}

// MARK: - NavigationViewCellDelegate

extension DiagnosisTableController: NavigationViewCellDelegate {
	func leftButtonPressed(onNavigationViewCell navigationViewCell: NavigationViewCell) {
		logic?.backButtonPressed()
	}

	func rightButtonPressed(onNavigationViewCell navigationViewCell: NavigationViewCell) {
		logic?.speakButtonPressed()
	}
}

// MARK: - DiagnosisMainCellDelegate

extension DiagnosisTableController: DiagnosisMainCellDelegate {
	func infoButtonPressed(onMainCell mainCell: DiagnosisMainCell, index: Int) {
		guard let infoType = InfoType(rawValue: index + InfoType.amd.rawValue) else { fatalError() }
		logic?.infoButtonPressed(type: infoType)
	}
}
