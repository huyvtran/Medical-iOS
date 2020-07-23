import RealmSwift
import SwipeCellKit
import UIKit

class ContactDetailsTableController: NSObject {
	// MARK: - Properties

	/// The table view this controller manages.
	private let tableView: UITableView

	/// A reference to the logic to inform about cell actions.
	private weak var logic: ContactDetailsLogicInterface?

	/// The model applied for display the content.
	private var displayModel: ContactDetailsDisplayModel.UpdateDisplay?

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
	init(tableView: UITableView, logic: ContactDetailsLogicInterface) {
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
		tableView.contentInset = tableViewContentInset

		// Register cells
		tableView.register(ContactDetailsMainCell.self)
		tableView.register(StaticTextCell.self)
		tableView.register(NavigationViewCell.self)

		// Register for keyboard notifications.
		keyboardController.delegate = self
	}

	// MARK: - Table content

	/// The data representation for the table view.
	private var tableData = [ContactDetailsTableData]()

	/// The order of the contact information type cells in table view.
	private let contactInfoOrder: [ContactInfoType] = [.name, .mobile, .phone, .email, .web, .street, .city]

	/**
	 Creates the data for the table view by mapping the `rawData` with the given display model.
	 Does not reload the table view itself.

	 - parameter model: The model to apply for displaying the content.
	 */
	private func createTableData(model: ContactDetailsDisplayModel.UpdateDisplay) {
		// Clear data.
		tableData = [ContactDetailsTableData]()

		// Add the navigation view as first cell on large style.
		if model.largeStyle {
			tableData.append(.navigation)
		}

		// Add a static label cell to show the contact type if it's pre-defined type.
		let type = model.contactModel.type
		if type != .custom && type != .amdNet {
			tableData.append(.contactTitle)
		}
		// Add the main cells for the contact info types.
		for contactInfoType in contactInfoOrder {
			if type == .amdNet && contactInfoType == .mobile { continue }
			tableData.append(.entry(contactInfoType))
		}

		// Creates the speech data.
		createSpeechData(model: model)
	}

	/**
	 Creates the speech data for the table view by mapping the `tableData` with the given display model.

	 - parameter model: The model to apply for displaying the content.
	 */
	private func createSpeechData(model: ContactDetailsDisplayModel.UpdateDisplay) {
		var rowIndex = model.largeStyle ? 1 : 0
		var speechData = [SpeechData]()

		for data in tableData {
			let speechText: String
			switch data {
			case .navigation:
				continue
			case .contactTitle:
				speechText = model.contactModel.type.speechString()
			case let .entry(infoType):
				switch infoType {
				case .name:
					speechText = model.contactModel.name ?? infoType.speechString()
				case .mobile:
					speechText = model.contactModel.mobile ?? infoType.speechString()
				case .phone:
					speechText = model.contactModel.phone ?? infoType.speechString()
				case .email:
					speechText = model.contactModel.email ?? infoType.speechString()
				case .street:
					speechText = model.contactModel.street ?? infoType.speechString()
				case .city:
					speechText = model.contactModel.city ?? infoType.speechString()
				case .web:
					speechText = model.contactModel.web ?? infoType.speechString()
				}
			}

			let indexPath = IndexPath(row: rowIndex, section: 0)
			let speech = SpeechData(text: speechText, indexPath: indexPath)
			speechData.append(speech)
			rowIndex += 1
		}

		logic?.setSpeechData(data: speechData)
	}

	// MARK: - Realm

	/// The notification token for observing any contact detail changes.
	private var contactDetailToken: RealmSwift.NotificationToken?

	/// The block invoked when any changes to the contact details applies.
	private lazy var contactDetailNotificationBlock: (ObjectChange) -> Void = { [weak self] change in
		guard let strongSelf = self else { return }
		guard let displayModel = strongSelf.displayModel else { return }
		let contactModel = displayModel.contactModel
		let tableView = strongSelf.tableView

		switch change {
		case let .change(properties):
			var rowIndex = (contactModel.type == .custom ? 0 : 1) + (displayModel.largeStyle ? 1 : 0)
			for property in properties {
				switch property.name {
				case "name":
					if let index = strongSelf.contactInfoOrder.index(of: .name) {
						rowIndex += index
					}
				case "mobile":
					if let index = strongSelf.contactInfoOrder.index(of: .mobile) {
						rowIndex += index
					}
				case "phone":
					if let index = strongSelf.contactInfoOrder.index(of: .phone) {
						rowIndex += index
					}
				case "email":
					if let index = strongSelf.contactInfoOrder.index(of: .email) {
						rowIndex += index
					}
				case "web":
					if let index = strongSelf.contactInfoOrder.index(of: .web) {
						rowIndex += index
					}
				case "street":
					if let index = strongSelf.contactInfoOrder.index(of: .street) {
						rowIndex += index
					}
				case "city":
					if let index = strongSelf.contactInfoOrder.index(of: .city) {
						rowIndex += index
					}
				default:
					fatalError()
				}
			}
			tableView.beginUpdates()
			tableView.reloadRows(at: [IndexPath(row: rowIndex, section: 0)], with: .none)
			tableView.endUpdates()

			// Update speech data with changes.
			strongSelf.createSpeechData(model: displayModel)
		case .deleted:
			// Impossible because this scene doesn't delete the model.
			fatalError()
		case let .error(error):
			Log.warn("Realm error for medicament results: \(error)")
			strongSelf.logic?.databaseWriteError()
		}
	}
}

// MARK: - ContactDetailsTableControllerInterface

extension ContactDetailsTableController: ContactDetailsTableControllerInterface {
	func setData(model: ContactDetailsDisplayModel.UpdateDisplay) {
		displayModel = model
		createTableData(model: model)
		contactDetailToken = displayModel?.contactModel.observe(contactDetailNotificationBlock)

		// Bring the content to the top and reload the table next frame.
		tableView.contentOffset = .zero
		DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
			guard let strongSelf = self else { return }
			strongSelf.tableView.reloadData()
		}
	}

	func scrollToTop() {
		tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
	}

	func setHighlight(indexPath: IndexPath, highlight: Bool) {
		guard let cell = tableView.cellForRow(at: indexPath) else { return }

		// Update cell's state.
		tableView.scrollToRow(at: indexPath, at: .top, animated: true)
		if cell.accessibilityIdentifier == ContactDetailsTableData.contactTitle.accessibilityIdentifier {
			if highlight {
				tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
			} else {
				tableView.deselectRow(at: indexPath, animated: true)
			}
		} else if let mainCell = cell as? ContactDetailsMainCell {
			mainCell.setSpeechHighlight(highlight)
		}
	}
}

// MARK: - UITableViewDataSource

extension ContactDetailsTableController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tableData.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let data = tableData[indexPath.row]
		switch data {
		case .contactTitle:
			return contactTitleCell()
		case let .entry(contactInfoType):
			return entryCell(contactInfoType: contactInfoType)
		case .navigation:
			return navigationViewCell()
		}
	}

	// MARK: - Cells

	private func contactTitleCell() -> StaticTextCell {
		guard let cell = tableView.dequeueReusableCell(for: StaticTextCell.self) else { fatalError() }
		guard let displayModel = displayModel else { fatalError() }

		let contactType = displayModel.contactModel.type
		let cellModel = StaticTextCellModel(
			accessibilityIdentifier: ContactDetailsTableData.contactTitle.accessibilityIdentifier,
			title: contactType.displayString(),
			speechTitle: nil,
			largeFont: displayModel.largeStyle,
			defaultColor: contactType.defaultColor(),
			highlightColor: contactType.highlightColor(),
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

	private func entryCell(contactInfoType: ContactInfoType) -> ContactDetailsMainCell {
		guard let cell = tableView.dequeueReusableCell(for: ContactDetailsMainCell.self) else { fatalError() }
		guard let displayModel = displayModel else { fatalError() }

		let contactModel = displayModel.contactModel
		let actable: Bool
		let title: String?
		let identifier: String?
		switch contactInfoType {
		case .name:
			title = contactModel.name
			identifier = ContactDetailsTableData.entry(.name).accessibilityIdentifier
			actable = false
		case .mobile:
			title = contactModel.mobile
			identifier = ContactDetailsTableData.entry(.mobile).accessibilityIdentifier
			actable = !(title?.isEmpty ?? true)
		case .phone:
			title = contactModel.phone
			identifier = ContactDetailsTableData.entry(.phone).accessibilityIdentifier
			actable = !(title?.isEmpty ?? true)
		case .email:
			title = contactModel.email
			identifier = ContactDetailsTableData.entry(.email).accessibilityIdentifier
			actable = !(title?.isEmpty ?? true)
		case .web:
			title = contactModel.web
			identifier = ContactDetailsTableData.entry(.web).accessibilityIdentifier
			actable = !(title?.isEmpty ?? true)
		case .street:
			title = contactModel.street
			identifier = ContactDetailsTableData.entry(.street).accessibilityIdentifier
			actable = false
		case .city:
			title = contactModel.city
			identifier = ContactDetailsTableData.entry(.city).accessibilityIdentifier
			actable = false
		}
		let editable = contactModel.type == .amdNet ? false : !(title?.isEmpty ?? true)

		let cellModel = ContactDetailsMainCellModel(
			accessibilityIdentifier: identifier,
			type: contactInfoType,
			title: title,
			defaultColor: contactModel.type.defaultColor(),
			highlightColor: contactModel.type.highlightColor(),
			editable: editable,
			actable: actable,
			largeStyle: displayModel.largeStyle,
			delegate: self
		)

		cell.setup(model: cellModel)
		cell.delegate = editable ? self : nil
		return cell
	}

	private func navigationViewCell() -> NavigationViewCell {
		guard let cell = tableView.dequeueReusableCell(for: NavigationViewCell.self) else { fatalError() }
		let cellModel = NavigationViewCellModel(
			title: R.string.contactDetails.title(),
			color: Const.Color.white,
			largeStyle: true,
			separatorVisible: true,
			leftButtonVisible: true,
			leftButtonType: .back,
			rightButtonVisible: true,
			rightButtonType: .speaker,
			delegate: self
		)
		cell.setup(model: cellModel)
		return cell
	}
}

// MARK: - UITableViewDelegate

extension ContactDetailsTableController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		let data = tableData[indexPath.row]

		switch data {
		case .entry(.mobile):
			return indexPath
		case .entry(.phone):
			return indexPath
		case .entry(.email):
			return indexPath
		case .entry(.web):
			return indexPath
		default:
			return nil
		}
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

		guard let displayModel = displayModel else { fatalError() }
		let contactModel = displayModel.contactModel
		let data = tableData[indexPath.row]

		switch data {
		case .entry(.mobile):
			guard let mobileNumber = contactModel.mobile else { return }
			logic?.sendSms(mobileNumber: mobileNumber)
		case .entry(.phone):
			guard let phoneNumber = contactModel.phone else { return }
			logic?.startPhoneCall(phoneNumber: phoneNumber)
		case .entry(.email):
			guard let emailAddress = contactModel.email else { return }
			logic?.sendEmail(emailAddress: emailAddress)
		case .entry(.web):
			guard let webAddress = contactModel.web else { return }
			logic?.openWeb(webAddress: webAddress)
		default:
			fatalError("Cell shouldn't be selectable")
		}
	}
}

// MARK: - ContactDetailsMainCellDelegate

extension ContactDetailsTableController: ContactDetailsMainCellDelegate {
	func dragIndicatorButtonPressed(onMainCell mainCell: ContactDetailsMainCell) {
		if mainCell.swipeOffset == 0 {
			mainCell.showSwipe(orientation: .left, animated: true, completion: nil)
		} else {
			mainCell.hideSwipe(animated: true)
		}
	}

	func textFieldDidBeginEditing(_ textField: UITextField) {
		textField.placeholder = String.empty
	}

	func textFieldDidEndEditing(_ textField: UITextField) {
		guard let displayModel = displayModel else { fatalError() }
		guard let type = ContactInfoType(rawValue: textField.tag) else { fatalError() }

		// Hide keyboard.
		textField.resignFirstResponder()

		// Get content.
		var content: String?
		if let text = textField.text, !text.isEmpty {
			content = text
		}

		// Updates the contact model.
		if !displayModel.dataModelManager.updateContactModel(displayModel.contactModel, contactInfoType: type, content: content) {
			logic?.databaseWriteError()
		}
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}

// MARK: - SwipeTableViewCellDelegate

extension ContactDetailsTableController: SwipeTableViewCellDelegate {
	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
		guard let displayModel = displayModel else { fatalError() }
		let contactModel = displayModel.contactModel

		let deleteAction = SwipeAction(style: .destructive, title: R.string.contactDetails.deleteButtonTitle(), handler: { [weak self] _, indexPath in
			let rowIndex = (contactModel.type == .custom ? indexPath.row + 1 : indexPath.row) - (displayModel.largeStyle ? 1 : 0)
			if let contactInfoType = ContactInfoType(rawValue: rowIndex) {
				if !displayModel.dataModelManager.updateContactModel(contactModel, contactInfoType: contactInfoType, content: nil) {
					self?.logic?.databaseWriteError()
				}
			}
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

extension ContactDetailsTableController: NavigationViewCellDelegate {
	func leftButtonPressed(onNavigationViewCell navigationViewCell: NavigationViewCell) {
		logic?.backButtonPressed()
	}

	func rightButtonPressed(onNavigationViewCell navigationViewCell: NavigationViewCell) {
		logic?.speakButtonPressed()
	}
}

// MARK: - KeyboardControllerDelegate

extension ContactDetailsTableController: KeyboardControllerDelegate {
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
