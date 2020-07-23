import RealmSwift
import SwipeCellKit
import UIKit

class ContactTableController: NSObject {
	// MARK: - Properties

	/// The table view this controller manages.
	private let tableView: UITableView

	/// A reference to the logic to inform about cell actions.
	private weak var logic: ContactLogicInterface?

	/// The model applied for display the content.
	private var displayModel: ContactDisplayModel.UpdateDisplay?

	/// The contact models to display in the table.
	private var contactModels: Results<ContactModel>?

	// MARK: - Init

	/**
	 Sets up the controller with needed references.

	 - parameter tableView: The reference to the table view this controller should manage.
	 - parameter logic: The logic which becomes the delegate to inform about cell actions. Will not be retained.
	 */
	init(tableView: UITableView, logic: ContactLogicInterface) {
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
		tableView.register(ContactMainCell.self)
		tableView.register(NavigationViewCell.self)
	}

	// MARK: - Realm

	/// The notification token for observing any contact result changes.
	private var contactResultsToken: RealmSwift.NotificationToken?

	/// The block invoked when any changes to the contact results applies.
	private lazy var contactResultsNotificationBlock: (RealmCollectionChange<Results<ContactModel>>) -> Void = { [weak self] changes in
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
		case let .error(error):
			Log.warn("Realm error for medicament results: \(error)")
			strongSelf.logic?.databaseWriteError()
		}
	}

	/**
	 Deletes a contact model at a specific index path.

	 - parameter indexPath: The cell's index path representing the model.
	 */
	private func deleteContactModel(indexPath: IndexPath) {
		guard let displayModel = displayModel else { fatalError() }
		precondition(cellType(indexPath: indexPath) == .main)
		guard let dataModels = contactModels else { fatalError() }

		// Get model.
		let contactModel = dataModels[indexPath.row]

		// Delete model from database.
		if !displayModel.dataModelManager.deleteContactModel(contactModel) {
			logic?.databaseWriteError()
		}
	}
}

// MARK: - ContactTableControllerInterface

extension ContactTableController: ContactTableControllerInterface {
	func setData(model: ContactDisplayModel.UpdateDisplay) {
		displayModel = model

		// Bring the content to the top and reload the table next frame.
		tableView.contentOffset = .zero

		// Create realm results and observer.
		contactModels = model.dataModelManager.getContactModels()
		contactResultsToken = contactModels?.observe(contactResultsNotificationBlock)
	}
}

// MARK: - UITableViewDataSource

extension ContactTableController: UITableViewDataSource {
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
		guard let contactModels = contactModels else { return 0 }
		return contactModels.count
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
	private func cellType(indexPath: IndexPath) -> ContactTableCellType {
		guard let displayModel = displayModel else { fatalError() }
		if displayModel.largeStyle && indexPath.section == 0 {
			return .navigation
		} else {
			return .main
		}
	}

	// MARK: - Cells

	private func mainCell(indexPath: IndexPath) -> ContactMainCell {
		guard let cell = tableView.dequeueReusableCell(for: ContactMainCell.self) else {
			fatalError("No cell available")
		}
		guard let displayModel = displayModel else { fatalError() }
		guard let contactModels = contactModels else { fatalError() }

		// Prepare states.
		let contactModel = contactModels[indexPath.row]
		let title: String
		let editable: Bool
		if contactModel.type == .custom {
			if let name = contactModel.name {
				title = name
			} else {
				title = R.string.contact.unnamed()
			}
			editable = true
		} else {
			title = contactModel.type.displayString()
			editable = false
		}

		// Set up cell.
		let cellModel = ContactMainCellModel(
			title: title,
			defaultColor: contactModel.type.defaultColor(),
			highlightColor: contactModel.type.highlightColor(),
			editable: editable,
			largeStyle: displayModel.largeStyle,
			delegate: self
		)
		cell.setup(model: cellModel)
		cell.delegate = editable ? self : nil
		return cell
	}

	private func navigationViewCell() -> NavigationViewCell {
		guard let cell = tableView.dequeueReusableCell(for: NavigationViewCell.self) else {
			fatalError("No cell available")
		}

		// Set up cell.
		let model = NavigationViewCellModel(
			title: R.string.contact.title(),
			color: Const.Color.white,
			largeStyle: true,
			separatorVisible: true,
			leftButtonVisible: true,
			leftButtonType: .back,
			rightButtonVisible: true,
			rightButtonType: .add,
			delegate: self
		)
		cell.setup(model: model)
		return cell
	}
}

// MARK: - UITableViewDelegate

extension ContactTableController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		// The main content and input cell can be selected.
		switch cellType(indexPath: indexPath) {
		case .main:
			return indexPath
		default:
			return nil
		}
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let contactModels = contactModels else { fatalError() }

		tableView.deselectRow(at: indexPath, animated: false)

		switch cellType(indexPath: indexPath) {
		case .main:
			let contactModel = contactModels[indexPath.row]
			logic?.contactSelected(contactModel)
		default:
			break
		}
	}
}

// MARK: - ContactMainCellDelegate

extension ContactTableController: ContactMainCellDelegate {
	func dragIndicatorButtonPressed(onMainCell mainCell: ContactMainCell) {
		if mainCell.swipeOffset == 0 {
			mainCell.showSwipe(orientation: .left, animated: true, completion: nil)
		} else {
			mainCell.hideSwipe(animated: true)
		}
	}
}

// MARK: - SwipeTableViewCellDelegate

extension ContactTableController: SwipeTableViewCellDelegate {
	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
		guard let displayModel = displayModel else { fatalError() }

		let deleteAction = SwipeAction(style: .destructive, title: R.string.contact.deleteButtonTitle(), handler: { [weak self] _, indexPath in
			self?.deleteContactModel(indexPath: indexPath)
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

extension ContactTableController: NavigationViewCellDelegate {
	func leftButtonPressed(onNavigationViewCell navigationViewCell: NavigationViewCell) {
		logic?.backButtonPressed()
	}

	func rightButtonPressed(onNavigationViewCell navigationViewCell: NavigationViewCell) {
		logic?.addButtonPressed()
	}
}
