import RealmSwift
import SwipeCellKit
import UIKit

class MedicamentTableController: NSObject {
	// MARK: - Properties

	/// The table view this controller manages.
	private let tableView: UITableView

	/// A reference to the logic to inform about cell actions.
	private weak var logic: MedicamentLogicInterface?

	/// The model applied for display the content.
	private var displayModel: MedicamentDisplayModel.UpdateDisplay?

	/// The medicament models to display in the table.
	private var medicamentModels: Results<MedicamentModel>?

	/// The table view's content insets.
	private let tableViewContentInset = UIEdgeInsets.zero

	/// The keyboard controller which manages the keyboard notification.
	var keyboardController = KeyboardController()

	// MARK: - Init

	/**
	 Sets up the controller with needed references.

	 - parameter tableView: The reference to the table view this controller should manage.
	 - parameter logic: The logic which becomes the delegate to inform about cell actions. Will not be retained.
	 */
	init(tableView: UITableView, logic: MedicamentLogicInterface) {
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
		tableView.contentInset = tableViewContentInset
		tableView.allowsMultipleSelection = true

		// Register cells.
		tableView.register(MedicamentMainCell.self)
		tableView.register(MedicamentInputCell.self)
		tableView.register(NavigationViewCell.self)

		// Register for keyboard notifications.
		keyboardController.delegate = self
	}

	// MARK: - Realm

	/// The notification token for observing any medicament result changes.
	private var medicamentResultsToken: RealmSwift.NotificationToken?

	/// The block invoced when any changes to the medicament results applies.
	private lazy var medicamentResultsNotificationBlock: (RealmCollectionChange<Results<MedicamentModel>>) -> Void = { [weak self] changes in
		guard let strongSelf = self else { return }
		let tableView = strongSelf.tableView
		guard let displayModel = strongSelf.displayModel else { return }
		let mainCellSection = displayModel.largeStyle ? 1 : 0

		switch changes {
		case .initial:
			tableView.reloadData()
		case let .update(_, deletions, insertions, modifications):
			tableView.beginUpdates()
			tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: mainCellSection) }), with: .bottom)
			tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: mainCellSection) }), with: .bottom)
			tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: mainCellSection) }), with: .none)
			tableView.endUpdates()

			// Update speech data for insertions and deletions.
			if insertions.count > 0 || deletions.count > 0 {
				strongSelf.createSpeechData(model: displayModel)
			}
		case let .error(error):
			Log.warn("Realm error for medicament results: \(error)")
			strongSelf.logic?.databaseWriteError()
		}
	}

	/**
	 Deletes a medicament model at a specific index path.

	 - parameter indexPath: The cell's index path representing the model.
	 */
	private func deleteMedicamentModel(indexPath: IndexPath) {
		guard let displayModel = displayModel else { fatalError() }
		precondition(cellType(indexPath: indexPath) == .main)
		guard let dataModels = medicamentModels else { fatalError() }

		// Get model.
		let medicamentModel = dataModels[indexPath.row]

		// Delete model from database.
		if !displayModel.dataModelManager.deleteMedicamentModel(medicamentModel) {
			logic?.databaseWriteError()
		}
	}

	/**
	 Creates the speech data for the table view with the given display model.

	 - parameter model: The model to apply for displaying the content.
	 */
	func createSpeechData(model: MedicamentDisplayModel.UpdateDisplay) {
		var speechData = [SpeechData]()

		// Make speech data for the input cell.
		let sectionIndex = model.largeStyle ? 1 : 0
		let speechTextForInput = R.string.medicament.cellMoreSpeech()
		let indexPathForInput = IndexPath(row: 0, section: sectionIndex + 1)
		let dataForInput = SpeechData(text: speechTextForInput, indexPath: indexPathForInput)

		guard let dataModels = medicamentModels else {
			// The speech data for the input cell must be added.
			speechData.append(dataForInput)
			logic?.setSpeechData(data: speechData)
			return
		}

		// Make speech data using the medicament models.
		var rowIndex = 0
		for model in dataModels {
			let text = model.name
			let indexPath = IndexPath(row: rowIndex, section: sectionIndex)
			let data = SpeechData(text: text, indexPath: indexPath)
			rowIndex += 1
			speechData.append(data)
		}
		// Add speech data for the input cell.
		speechData.append(dataForInput)

		logic?.setSpeechData(data: speechData)
	}
}

// MARK: - MedicamentTableControllerInterface

extension MedicamentTableController: MedicamentTableControllerInterface {
	func setData(model: MedicamentDisplayModel.UpdateDisplay) {
		displayModel = model

		// Bring the content to the top and reload the table next frame.
		tableView.contentOffset = .zero

		// Create realm results and observer.
		medicamentModels = model.dataModelManager.getMedicamentModels()
		medicamentResultsToken = medicamentModels?.observe(medicamentResultsNotificationBlock)

		// Creates speech data.
		createSpeechData(model: model)
	}

	func scrollToTop() {
		tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
	}

	func setHighlight(indexPath: IndexPath, highlight: Bool) {
		guard let cell = tableView.cellForRow(at: indexPath) else { return }

		// Update cell's state.
		tableView.scrollToRow(at: indexPath, at: .top, animated: true)
		let type = cellType(indexPath: indexPath)
		if type == .main, let mainCell = cell as? MedicamentMainCell {
			mainCell.setSpeechHighlight(highlight)
		} else if type == .input, let inputCell = cell as? MedicamentInputCell {
			inputCell.setSpeechHighlight(highlight)
		}
	}
}

// MARK: - UITableViewDataSource

extension MedicamentTableController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		guard let displayModel = displayModel else { return 0 }
		return displayModel.largeStyle ? 3 : 2
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let displayModel = displayModel else { return 0 }

		if displayModel.largeStyle && section == 0 {
			// Navigation view.
			return 1
		}

		if (displayModel.largeStyle && section == 2) ||
			(!displayModel.largeStyle && section == 1) {
			// TextInput view.
			return 1
		}

		// Content list.
		guard let medicamentModels = medicamentModels else { return 0 }
		return medicamentModels.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch cellType(indexPath: indexPath) {
		case .main:
			return mainCell(indexPath: indexPath)
		case .input:
			return inputCell()
		case .navigation:
			return navigationViewCell()
		}
	}

	/**
	 Determines the cell type at a given index path taking the display model into count.

	 - parameter indexPath: The cell's index path.
	 - returns: The cell's type.
	 */
	private func cellType(indexPath: IndexPath) -> MedicamentTableCellType {
		guard let displayModel = displayModel else { fatalError() }
		if displayModel.largeStyle && indexPath.section == 0 {
			return .navigation
		} else if (displayModel.largeStyle && indexPath.section == 2) ||
			(!displayModel.largeStyle && indexPath.section == 1) {
			return .input
		} else {
			return .main
		}
	}

	// MARK: - Cells

	private func mainCell(indexPath: IndexPath) -> MedicamentMainCell {
		guard let cell = tableView.dequeueReusableCell(for: MedicamentMainCell.self) else {
			fatalError("No cell available")
		}
		guard let displayModel = displayModel else { fatalError() }
		guard let medicamentModels = medicamentModels else { fatalError() }

		// Set up cell.
		let medicamentModel = medicamentModels[indexPath.row]
		let cellModel = MedicamentMainCellModel(
			title: medicamentModel.name,
			editable: medicamentModel.editable,
			largeStyle: displayModel.largeStyle,
			delegate: self
		)
		cell.setup(model: cellModel)
		cell.delegate = medicamentModel.editable ? self : nil

		// Pre-select state, has to be told to the table view.
		if medicamentModel.selected {
			tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
		}

		return cell
	}

	private func inputCell() -> MedicamentInputCell {
		guard let cell = tableView.dequeueReusableCell(for: MedicamentInputCell.self) else {
			fatalError("No cell available")
		}
		guard let displayModel = displayModel else { fatalError() }

		// Set up cell.
		let model = MedicamentInputCellModel(
			largeStyle: displayModel.largeStyle,
			delegate: self
		)
		cell.setup(model: model)
		return cell
	}

	private func navigationViewCell() -> NavigationViewCell {
		guard let cell = tableView.dequeueReusableCell(for: NavigationViewCell.self) else {
			fatalError("No cell available")
		}
		let model = NavigationViewCellModel(
			title: R.string.medicament.title(),
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
}

// MARK: - UITableViewDelegate

extension MedicamentTableController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		// The main content and input cell can be selected.
		switch cellType(indexPath: indexPath) {
		case .main, .input:
			return indexPath
		default:
			return nil
		}
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch cellType(indexPath: indexPath) {
		case .main:
			updateMedicamentModel(indexPath: indexPath, selected: true)
		case .input:
			// The text field becomes automatically first responder, just deselect the cell.
			tableView.deselectRow(at: indexPath, animated: false)
		default:
			break
		}
	}

	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		switch cellType(indexPath: indexPath) {
		case .main:
			updateMedicamentModel(indexPath: indexPath, selected: false)
		default:
			break
		}
	}

	/**
	 Updates the `selected` state of a medicament model at a specific index path.

	 - parameter indexPath: The cell's index path representing the model.
	 - parameter selected: Set to `true` when the model gets selected, `false` when deselected.
	 */
	private func updateMedicamentModel(indexPath: IndexPath, selected: Bool) {
		guard let logic = logic else { return }
		precondition(cellType(indexPath: indexPath) == .main)
		guard let displayModel = displayModel else { fatalError() }
		guard let medicamentModels = medicamentModels else { fatalError() }

		// Update model.
		let medicamentModel = medicamentModels[indexPath.row]
		if !displayModel.dataModelManager.setMedicamentModel(medicamentModel, selected: selected) {
			// Notify logic about error.
			logic.databaseWriteError()
		}
	}
}

// MARK: - SwipeTableViewCellDelegate

extension MedicamentTableController: SwipeTableViewCellDelegate {
	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
		guard let displayModel = displayModel else { fatalError() }

		let deleteAction = SwipeAction(style: .destructive, title: R.string.medicament.deleteButtonTitle(), handler: { [weak self] _, indexPath in
			self?.deleteMedicamentModel(indexPath: indexPath)
		})
		deleteAction.font = displayModel.largeStyle ? Const.Font.content1Large : Const.Font.content1Default
		deleteAction.textColor = Const.Color.white
		deleteAction.backgroundColor = Const.Color.magenta

		return [deleteAction]
	}

	func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
		var options = SwipeOptions()
		options.expansionStyle = .none
		options.transitionStyle = .drag
		return options
	}
}

// MARK: - NavigationViewCellDelegate

extension MedicamentTableController: NavigationViewCellDelegate {
	func leftButtonPressed(onNavigationViewCell navigationViewCell: NavigationViewCell) {
		logic?.backButtonPressed()
	}

	func rightButtonPressed(onNavigationViewCell navigationViewCell: NavigationViewCell) {
		logic?.speakButtonPressed()
	}
}

// MARK: - MedicamentMainCellDelegate

extension MedicamentTableController: MedicamentMainCellDelegate {
	func dragIndicatorButtonPressed(onMainCell mainCell: MedicamentMainCell) {
		if mainCell.swipeOffset == 0 {
			mainCell.showSwipe(orientation: .left, animated: true, completion: nil)
		} else {
			mainCell.hideSwipe(animated: true)
		}
	}
}

// MARK: - MedicamentInputCellDelegate

extension MedicamentTableController: MedicamentInputCellDelegate {
	func textFieldDidBeginEditing(_ textField: UITextField) {
		textField.placeholder = String.empty
	}

	func textFieldDidEndEditing(_ textField: UITextField) {
		let text = textField.text

		// Hide keyboard.
		textField.resignFirstResponder()

		// Reset text field
		textField.placeholder = R.string.medicament.cellMore()
		textField.placeholderColor = Const.Color.lightMain
		textField.text = String.empty

		// Create new model if a name is provided.
		if let text = text, !text.isEmpty {
			guard let displayModel = displayModel else { fatalError() }
			displayModel.dataModelManager.createMedicamentModel(name: text)
		}
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}

// MARK: - KeyboardControllerDelegate

extension MedicamentTableController: KeyboardControllerDelegate {
	func keyboardShows(keyboardSize: CGSize) {
		var contentInsets = tableViewContentInset
		contentInsets.bottom = keyboardSize.height
		tableView.contentInset = contentInsets
	}

	func keyboardShown() {
		// If active control is not visible, scroll to it.
		if let firstResponder = UIResponder.findFirstResponder(), let control = firstResponder as? UIControl {
			let controlPosition = tableView.convert(control.frame, from: control.superview).insetBy(dx: 0, dy: -Const.Size.defaultGap * 2)
			tableView.scrollRectToVisible(controlPosition, animated: true)
		}
	}

	func keyboardHides() {
		tableView.contentInset = tableViewContentInset
	}

	func keyboardHidden() {}
}
