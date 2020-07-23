import UIKit

class SearchTableController: NSObject {
	// MARK: - Properties

	/// The table view this controller manages.
	private let tableView: UITableView

	/// A reference to the logic to inform about cell actions.
	private weak var logic: SearchLogicInterface?

	/// The model applied for display the content.
	private var displayModel: SearchDisplayModel.UpdateDisplay?

	/// The table view's content insets.
	private var tableViewContentInset = UIEdgeInsets.zero

	/// The keyboard controller which manages the keyboard notification.
	var keyboardController = KeyboardController()

	// MARK: - Init

	/**
	 Sets up the controller with needed references.

	 - parameter tableView: The reference to the table view this controller should manage.
	 - parameter logic: The logic which becomes the delegate to inform about cell actions. Will not be retained.
	 */
	init(tableView: UITableView, logic: SearchLogicInterface) {
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

		// Table footer
		let footer = UIView(frame: .zero)
		tableView.tableFooterView = footer

		// Register cells
		tableView.register(NavigationViewCell.self)
		tableView.register(SearchInputCell.self)
		tableView.register(StaticTextCell.self)

		// Register for keyboard notifications.
		keyboardController.delegate = self
	}

	// MARK: - Table content

	/// The raw list of entries for the table view without any display states applied for cells.
	private var rawData = [
		SearchTableControllerRawEntry()
	]

	/// The data representation for the table view.
	private var tableData = [SearchTableData]()

	/**
	 Creates the data for the table view by mapping the `rawData` with the given display model.
	 Does not reload the table view itself.

	 - parameter model: The model to apply for displaying the content.
	 */
	private func createTableData(model: SearchDisplayModel.UpdateDisplay) {
		// Clear data.
		tableData = [SearchTableData]()

		// Add the navigation view as first cell on large style.
		if model.largeStyle {
			let navigationViewCellModel = NavigationViewCellModel(
				title: R.string.search.title(),
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

		// Add the search input cell at the top.
		tableData.append(.search)

		// Append search results.
		if let searchString = model.searchString?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines), !searchString.isEmpty {
			// Get all entries matching the search.
			let allInfoEntries = InfoType.allCases
			let filteredEntries = allInfoEntries.filter { entry in
				let title = entry.titleString().lowercased()
				if title.contains(searchString) {
					return true
				}
				let content = entry.contentString().lowercased()
				return content.contains(searchString)
			}

			// Sort the entries.
			let sortedEntries = filteredEntries.sorted { (leftElement, rightElement) -> Bool in
				return leftElement.titleString().compare(rightElement.titleString()) == .orderedAscending
			}

			// Map the sorted entries to table data.
			let tableEntries = sortedEntries.map { (element) -> SearchTableData in
				let cellModel = StaticTextCellModel(
					accessibilityIdentifier: "Result \(element.rawValue)",
					title: element.titleString(),
					speechTitle: nil,
					largeFont: model.largeStyle,
					defaultColor: Const.Color.darkMain,
					highlightColor: Const.Color.white,
					backgroundColor: Const.Color.lightMain,
					separatorVisible: true,
					separatorDefaultColor: Const.Color.darkMain,
					separatorHighlightColor: Const.Color.white,
					disabled: false,
					centeredText: false
				)
				return SearchTableData.staticText(cellModel, element)
			}

			// Append entries to the table data.
			tableData.append(contentsOf: tableEntries)
		}

		// Use the last cell's background color for the footer.
		if let lastCell = tableData.last {
			switch lastCell {
			case let .navigation(cellModel):
				tableFooterColor = cellModel.color
			case .search:
				tableFooterColor = Const.Color.darkMain
			case let .staticText(cellModel, _):
				tableFooterColor = cellModel.backgroundColor
			}
		} else {
			tableFooterColor = .clear
		}
	}

	/// The color of the table footer view.
	private var tableFooterColor: UIColor? {
		get {
			return tableView.tableFooterView?.backgroundColor
		}
		set {
			tableView.tableFooterView?.backgroundColor = newValue
		}
	}
}

// MARK: - SearchTableControllerInterface

extension SearchTableController: SearchTableControllerInterface {
	func setData(model: SearchDisplayModel.UpdateDisplay) {
		displayModel = model
		createTableData(model: model)
		tableView.reloadData()
		tableView.contentOffset = .zero
	}

	func updateFooterSize() {
		guard let footerView = tableView.tableFooterView else { return }

		footerView.frame.size = tableView.frame.size
		tableViewContentInset = UIEdgeInsets(top: 0, left: 0, bottom: -footerView.frame.size.height, right: 0)
		tableView.contentInset = tableViewContentInset
	}
}

// MARK: - UITableViewDataSource

extension SearchTableController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tableData.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let data = tableData[indexPath.row]
		switch data {
		case let .navigation(model):
			return navigationViewCell(model: model)
		case .search:
			return searchInputCell()
		case let .staticText(model, _):
			return resultCell(model: model)
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

	private func searchInputCell() -> SearchInputCell {
		guard let cell = tableView.dequeueReusableCell(for: SearchInputCell.self) else {
			fatalError("No cell available")
		}
		guard let displayModel = displayModel else { fatalError() }

		let cellModel = SearchInputCellModel(
			largeStyle: displayModel.largeStyle,
			searchText: displayModel.searchString,
			delegate: self
		)
		cell.setup(model: cellModel)
		return cell
	}

	private func resultCell(model: StaticTextCellModel) -> StaticTextCell {
		guard let cell = tableView.dequeueReusableCell(for: StaticTextCell.self) else {
			fatalError("No cell available")
		}
		cell.setup(model: model)
		return cell
	}
}

// MARK: - UITableViewDelegate

extension SearchTableController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		let data = tableData[indexPath.row]
		switch data {
		case .search:
			return indexPath
		case .staticText:
			return indexPath
		default:
			return nil
		}
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let data = tableData[indexPath.row]
		switch data {
		case .search:
			if let cell = tableView.cellForRow(at: indexPath) as? SearchInputCell {
				cell.makeTextFieldFirstResponder()
			}
		case let .staticText(_, infoType):
			tableView.deselectRow(at: indexPath, animated: true)
			logic?.routeToInfo(infoType: infoType)
		default:
			fatalError("Cell shouldn't be selectable")
		}
	}
}

// MARK: - NavigationViewCellDelegate

extension SearchTableController: NavigationViewCellDelegate {
	func leftButtonPressed(onNavigationViewCell navigationViewCell: NavigationViewCell) {
		logic?.backButtonPressed()
	}

	func rightButtonPressed(onNavigationViewCell navigationViewCell: NavigationViewCell) {}
}

// MARK: - SearchInputCellDelegate

extension SearchTableController: SearchInputCellDelegate {
	func textFieldDidBeginEditing(_ textField: UITextField) {
		textField.placeholder = String.empty
	}

	func textFieldDidEndEditing(_ textField: UITextField) {
		// Hide keyboard.
		textField.resignFirstResponder()

		// Get content.
		var content: String?
		if let text = textField.text, !text.isEmpty {
			content = text
		}

		// Inform logic about search string which triggers a reload of the table view.
		logic?.updateSearch(searchText: content)
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}

// MARK: - KeyboardControllerDelegate

extension SearchTableController: KeyboardControllerDelegate {
	func keyboardShows(keyboardSize: CGSize) {
		var contentInsets = tableViewContentInset
		contentInsets.bottom += keyboardSize.height
		tableView.contentInset = contentInsets
		tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
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
		tableView.scrollIndicatorInsets = .zero
	}

	func keyboardHidden() {}
}
