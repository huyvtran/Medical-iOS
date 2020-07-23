import UIKit

class MenuTableController: NSObject {
	// MARK: - Properties

	/// The table view this controller manages.
	private let tableView: UITableView

	/// A reference to the logic to inform about cell actions.
	private weak var logic: MenuLogicInterface?

	/// The model applied for display the content.
	private var displayModel: MenuDisplayModel.UpdateDisplay?

	/// The last appointments for the treatment cell if in the scene `doctorVisit`.
	private var lastAppointments: [AppointmentModel]?

	// MARK: - Init

	/**
	 Sets up the controller with needed references.

	 - parameter tableView: The reference to the table view this controller should manage.
	 - parameter logic: The logic which becomes the delegate to inform about cell actions. Will not be retained.
	 */
	init(tableView: UITableView, logic: MenuLogicInterface) {
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
		tableView.register(StaticTextCell.self)
		tableView.register(NavigationViewCell.self)
	}

	// MARK: - Table content

	/// The cell list for the table view in home (root) menu scene.
	private var homeCells: [MenuCellIdentifier] = [
		.doctorVisit, .newAppointment, .calendar, .contactPerson,
		.selfTest, .knowledge, .addresses, .news, .search,
		.settings, .manual, .inprint, .version
	]

	/// The cell list for the table view in doctor-visit sub menu scene.
	private var doctorVisitCells: [MenuCellIdentifier] = [
		.treatment, .diagnosis, .medicament, .visusInput, .nhdInput, .octVisus
	]

	/// The cell list for the table view in self-test sub menu scene.
	private var selfTestCells: [MenuCellIdentifier] = [
		.amslerTest, .readingTest
	]

	/// The cell list for the table view in the knowledge menu scene.
	private var knowledgeCells: [MenuCellIdentifier] = [
		.illness, .examination, .therapy, .activities, .aid, .support, .diagnose
	]

	/// The cell list for the table view in the settings menu scene.
	private var settingsCells: [MenuCellIdentifier] = [
		.reminder, .backup
	]

	/// The cell list for the table view in the illness menu scene.
	private var illnessCells: [MenuCellIdentifier] = [
		.illnessInfo0,
		.illnessInfo4, // intended
		.illnessInfo1, .illnessInfo2, .illnessInfo3,
		.illnessInfo5, .illnessInfo6, .illnessInfo7, .illnessInfo8, .illnessInfo9
	]

	/// The cell list for the table view in the examination menu scene.
	private var examinationCells: [MenuCellIdentifier] = [
		.examinationInfo0, .examinationInfo1, .examinationInfo2, .examinationInfo3,
		.examinationInfo5, .examinationInfo4, // 5 before 4 is intended
		.examinationInfo6
	]

	/// The cell list for the table view in the therapy menu scene.
	private var therapyCells: [MenuCellIdentifier] = [
		.therapyInfo0, .therapyInfo1, .therapyInfo2,
		.therapyInfo4, .therapyInfo3, // intended
		.therapyInfo5
	]

	/// The cell list for the table view in the activities menu scene.
	private var activitiesCells: [MenuCellIdentifier] = [
		.activitiesInfo0, .activitiesInfo1, .activitiesInfo2, .activitiesInfo3, .activitiesInfo4, .activitiesInfo5
	]

	/// The cell list for the table view in the aid menu scene.
	private var aidCells: [MenuCellIdentifier] = [
		.aidInfo7, // intended
		.aidInfo0, .aidInfo1, .aidInfo2, .aidInfo3, .aidInfo4, .aidInfo5, .aidInfo6
	]

	/// The cell list for the table view in the support menu scene.
	private var supportCells: [MenuCellIdentifier] = [
		.supportInfo0, .supportInfo1, .supportInfo2, .supportInfo3, .supportInfo4
	]

	/// The data representation for the table view.
	private var tableData = [MenuTableData]()

	/**
	 Creates the data for the table view by mapping the `rawData` with the given display model.
	 Does not reload the table view itself.

	 - parameter model: The model to apply for displaying the content.
	 */
	private func createTableData(model: MenuDisplayModel.UpdateDisplay) {
		// Clear data.
		tableData = [MenuTableData]()

		// Find last appointments for the doctorVisit scene.
		let today = Date()
		lastAppointments = nil
		if model.sceneId == .doctorVisit {
			let appointments = model.dataModelManager.getLastAppointments(upTo: today)
			if appointments.count > 0 {
				lastAppointments = appointments
			}
		}

		// Add the navigation view as first cell on large style.
		if model.largeStyle {
			let navigationViewCellModel = NavigationViewCellModel(
				title: model.sceneId.titleString(),
				color: Const.Color.white,
				largeStyle: true,
				separatorVisible: true,
				leftButtonVisible: !model.isRoot,
				leftButtonType: .back,
				rightButtonVisible: true,
				rightButtonType: .speaker,
				delegate: self
			)
			tableData.append(.navigation(navigationViewCellModel))
		}

		// Append the data cells for this scene.
		let mainCells = createTableDataEntries(model: model)
		tableData += mainCells

		// Use the last cell's background color for the footer.
		if let lastCell = tableData.last {
			switch lastCell {
			case let .navigation(cellModel):
				tableFooterColor = cellModel.color
			case let .staticText(cellModel, _):
				tableFooterColor = cellModel.backgroundColor
			}
		} else {
			tableFooterColor = .clear
		}

		// Use the main cells to provide the speech data to the logic.
		var rowIndex = model.largeStyle ? 1 : 0
		let speechData = mainCells.map { tableDataEntry -> SpeechData in
			let speechText: String
			switch tableDataEntry {
			case let .staticText(cellModel, .treatment):
				speechText = cellModel.speechTitle ?? MenuCellIdentifier.treatment.speechText()
			case let .staticText(_, cellIdentifier):
				speechText = cellIdentifier.speechText()
			default:
				fatalError()
			}
			let indexPath = IndexPath(row: rowIndex, section: 0)
			rowIndex += 1
			return SpeechData(text: speechText, indexPath: indexPath)
		}
		logic?.setSpeechData(data: speechData)
	}

	/**
	 Returns the table rows depending on the scene and the corresponding `rawData` as part of the table data.

	 - parameter model: The scene's display model for setting up the cells.
	 - returns: The list of table cells to append as main part to the scene's table data.
	 */
	private func createTableDataEntries(model: MenuDisplayModel.UpdateDisplay) -> [MenuTableData] {
		// Retrieve the raw data.
		var rawData = [MenuCellIdentifier]()
		switch model.sceneId {
		case .home:
			rawData = homeCells
		case .doctorVisit:
			rawData = doctorVisitCells
			// Handle special case `treatment`.
			if let appointments = lastAppointments, appointments.count > 0 {} else {
				// No appointments found, remove the treatment cell.
				guard let treatmentIndex = rawData.index(of: .treatment) else { fatalError("Treatment should be availble in raw data") }
				rawData.remove(at: treatmentIndex)
			}
		case .selfTest:
			rawData = selfTestCells
		case .knowledge:
			rawData = knowledgeCells
		case .settings:
			rawData = settingsCells
		case .illness:
			rawData = illnessCells
		case .examination:
			rawData = examinationCells
		case .therapy:
			rawData = therapyCells
		case .activities:
			rawData = activitiesCells
		case .aid:
			rawData = aidCells
		case .support:
			rawData = supportCells
		default:
			fatalError()
		}

		// Transform the raw data into displayable cells.
		let cells = rawData.map { cellIdentifier -> MenuTableData in
			if cellIdentifier == .treatment {
				guard let appointments = lastAppointments else { fatalError("Cell identifier should be filtered out before") }
				guard let firstAppointment = appointments.first else { fatalError("At least one element is expected") }

				let dateString = CommonDateFormatter.formattedStringWithWeekday(date: firstAppointment.date)
				let dateColor = appointments.count > 1 ? Const.Color.white : firstAppointment.type.defaultColor()
				let cellModel = StaticTextCellModel(
					accessibilityIdentifier: cellIdentifier.rawValue,
					title: dateString,
					speechTitle: dateString,
					largeFont: model.largeStyle,
					defaultColor: dateColor,
					highlightColor: Const.Color.white,
					backgroundColor: cellIdentifier.rawData().darkStyle ? Const.Color.darkMain : Const.Color.lightMain,
					separatorVisible: cellIdentifier.rawData().separatorVisible,
					separatorDefaultColor: cellIdentifier.rawData().darkStyle ? Const.Color.lightMain : Const.Color.darkMain,
					separatorHighlightColor: nil,
					disabled: false,
					centeredText: false
				)
				return MenuTableData.staticText(cellModel, cellIdentifier)
			} else {
				return MenuTableData.staticText(
					StaticTextCellModel(
						accessibilityIdentifier: cellIdentifier.rawValue,
						title: cellIdentifier.rawData().title,
						speechTitle: nil,
						largeFont: model.largeStyle,
						defaultColor: cellIdentifier.rawData().darkStyle ? Const.Color.lightMain : Const.Color.darkMain,
						highlightColor: Const.Color.white,
						backgroundColor: cellIdentifier.rawData().darkStyle ? Const.Color.darkMain : Const.Color.lightMain,
						separatorVisible: cellIdentifier.rawData().separatorVisible,
						separatorDefaultColor: nil,
						separatorHighlightColor: nil,
						disabled: false,
						centeredText: false
					),
					cellIdentifier
				)
			}
		}

		return cells
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

// MARK: - MenuTableControllerInterface

extension MenuTableController: MenuTableControllerInterface {
	func setData(model: MenuDisplayModel.UpdateDisplay) {
		displayModel = model

		// Reload table content.
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

	func updateFooterSize() {
		guard let footerView = tableView.tableFooterView else { return }

		footerView.frame.size = tableView.frame.size
		tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -footerView.frame.size.height, right: 0)
	}
}

// MARK: - UITableViewDataSource

extension MenuTableController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tableData.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let data = tableData[indexPath.row]
		switch data {
		case let .staticText(model, _):
			return textCell(model: model)
		case let .navigation(model):
			return navigationViewCell(model: model)
		}
	}

	// MARK: - Cells

	private func textCell(model: StaticTextCellModel) -> StaticTextCell {
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

extension MenuTableController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		let data = tableData[indexPath.row]
		switch data {
		case .staticText:
			return indexPath
		case .navigation:
			return nil
		}
	}

	// swiftlint:disable cyclomatic_complexity
	// swiftlint:disable function_body_length
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

		let data = tableData[indexPath.row]
		switch data {
		case .staticText(_, .doctorVisit):
			logic?.routeToMenu(sceneId: .doctorVisit)
		case .staticText(_, .newAppointment):
			logic?.routeToNewAppointment()
		case .staticText(_, .contactPerson):
			logic?.routeToContact()
		case .staticText(_, .selfTest):
			logic?.routeToMenu(sceneId: .selfTest)
		case .staticText(_, .diagnosis):
			logic?.routeToDiagnosis()
		case .staticText(_, .medicament):
			logic?.routeToMedicament()
		case .staticText(_, .visusInput):
			logic?.routeToVisusNhdInput(type: .visus)
		case .staticText(_, .nhdInput):
			logic?.routeToVisusNhdInput(type: .nhd)
		case .staticText(_, .calendar):
			logic?.routeToCalendar()
		case .staticText(_, .amslerTest):
			logic?.routeToAmslertest()
		case .staticText(_, .readingTest):
			logic?.routeToReadingTest()
		case .staticText(_, .octVisus):
			logic?.routeToGraph()

		case .staticText(_, .treatment):
			guard let date = lastAppointments?.first?.date else { fatalError("At least one entry expected") }
			logic?.routeToAppointmentDetail(date: date)

		case .staticText(_, .knowledge):
			logic?.routeToMenu(sceneId: .knowledge)
		case .staticText(_, .addresses):
			logic?.routeToInfo(infoType: .addresses)
		case .staticText(_, .news):
			logic?.routeToInfo(infoType: .news)
		case .staticText(_, .search):
			logic?.routeToSearch()
		case .staticText(_, .settings):
			logic?.routeToMenu(sceneId: .settings)
		case .staticText(_, .inprint):
			logic?.routeToInfo(infoType: .inprint)
		case .staticText(_, .version):
			logic?.routeToInfo(infoType: .version)

		case .staticText(_, .reminder):
			logic?.routeToReminder()
		case .staticText(_, .backup):
			logic?.routeToInfo(infoType: .backup)

		case .staticText(_, .manual):
			logic?.routeToInfo(infoType: .manual)
		case .staticText(_, .illness):
			logic?.routeToMenu(sceneId: .illness)
		case .staticText(_, .examination):
			logic?.routeToMenu(sceneId: .examination)
		case .staticText(_, .therapy):
			logic?.routeToMenu(sceneId: .therapy)
		case .staticText(_, .activities):
			logic?.routeToMenu(sceneId: .activities)
		case .staticText(_, .aid):
			logic?.routeToMenu(sceneId: .aid)
		case .staticText(_, .support):
			logic?.routeToMenu(sceneId: .support)
		case .staticText(_, .diagnose):
			logic?.routeToInfo(infoType: .diagnose)

		case .staticText(_, .illnessInfo0):
			logic?.routeToInfo(infoType: .illnessInfo0)
		case .staticText(_, .illnessInfo1):
			logic?.routeToInfo(infoType: .illnessInfo1)
		case .staticText(_, .illnessInfo2):
			logic?.routeToInfo(infoType: .illnessInfo2)
		case .staticText(_, .illnessInfo3):
			logic?.routeToInfo(infoType: .illnessInfo3)
		case .staticText(_, .illnessInfo4):
			logic?.routeToInfo(infoType: .illnessInfo4)
		case .staticText(_, .illnessInfo5):
			logic?.routeToInfo(infoType: .illnessInfo5)
		case .staticText(_, .illnessInfo6):
			logic?.routeToInfo(infoType: .illnessInfo6)
		case .staticText(_, .illnessInfo7):
			logic?.routeToInfo(infoType: .illnessInfo7)
		case .staticText(_, .illnessInfo8):
			logic?.routeToInfo(infoType: .illnessInfo8)
		case .staticText(_, .illnessInfo9):
			logic?.routeToInfo(infoType: .illnessInfo9)

		case .staticText(_, .examinationInfo0):
			logic?.routeToInfo(infoType: .examinationInfo0)
		case .staticText(_, .examinationInfo1):
			logic?.routeToInfo(infoType: .examinationInfo1)
		case .staticText(_, .examinationInfo2):
			logic?.routeToInfo(infoType: .examinationInfo2)
		case .staticText(_, .examinationInfo3):
			logic?.routeToInfo(infoType: .examinationInfo3)
		case .staticText(_, .examinationInfo4):
			logic?.routeToInfo(infoType: .examinationInfo4)
		case .staticText(_, .examinationInfo5):
			logic?.routeToInfo(infoType: .examinationInfo5)
		case .staticText(_, .examinationInfo6):
			logic?.routeToInfo(infoType: .examinationInfo6)

		case .staticText(_, .therapyInfo0):
			logic?.routeToInfo(infoType: .therapyInfo0)
		case .staticText(_, .therapyInfo1):
			logic?.routeToInfo(infoType: .therapyInfo1)
		case .staticText(_, .therapyInfo2):
			logic?.routeToInfo(infoType: .therapyInfo2)
		case .staticText(_, .therapyInfo3):
			logic?.routeToInfo(infoType: .therapyInfo3)
		case .staticText(_, .therapyInfo4):
			logic?.routeToInfo(infoType: .therapyInfo4)
		case .staticText(_, .therapyInfo5):
			logic?.routeToInfo(infoType: .therapyInfo5)

		case .staticText(_, .activitiesInfo0):
			logic?.routeToInfo(infoType: .activitiesInfo0)
		case .staticText(_, .activitiesInfo1):
			logic?.routeToInfo(infoType: .activitiesInfo1)
		case .staticText(_, .activitiesInfo2):
			logic?.routeToInfo(infoType: .activitiesInfo2)
		case .staticText(_, .activitiesInfo3):
			logic?.routeToInfo(infoType: .activitiesInfo3)
		case .staticText(_, .activitiesInfo4):
			logic?.routeToInfo(infoType: .activitiesInfo4)
		case .staticText(_, .activitiesInfo5):
			logic?.routeToInfo(infoType: .activitiesInfo5)

		case .staticText(_, .aidInfo0):
			logic?.routeToInfo(infoType: .aidInfo0)
		case .staticText(_, .aidInfo1):
			logic?.routeToInfo(infoType: .aidInfo1)
		case .staticText(_, .aidInfo2):
			logic?.routeToInfo(infoType: .aidInfo2)
		case .staticText(_, .aidInfo3):
			logic?.routeToInfo(infoType: .aidInfo3)
		case .staticText(_, .aidInfo4):
			logic?.routeToInfo(infoType: .aidInfo4)
		case .staticText(_, .aidInfo5):
			logic?.routeToInfo(infoType: .aidInfo5)
		case .staticText(_, .aidInfo6):
			logic?.routeToInfo(infoType: .aidInfo6)
		case .staticText(_, .aidInfo7):
			logic?.routeToInfo(infoType: .aidInfo7)

		case .staticText(_, .supportInfo0):
			logic?.routeToInfo(infoType: .supportInfo0)
		case .staticText(_, .supportInfo1):
			logic?.routeToInfo(infoType: .supportInfo1)
		case .staticText(_, .supportInfo2):
			logic?.routeToInfo(infoType: .supportInfo2)
		case .staticText(_, .supportInfo3):
			logic?.routeToInfo(infoType: .supportInfo3)
		case .staticText(_, .supportInfo4):
			logic?.routeToInfo(infoType: .supportInfo4)

		default:
			Log.warn("Selection not implemented")
		}
	}

	// swiftlint:enable cyclomatic_complexity
	// swiftlint:enable function_body_length
}

// MARK: - NavigationViewCellDelegate

extension MenuTableController: NavigationViewCellDelegate {
	func leftButtonPressed(onNavigationViewCell navigationViewCell: NavigationViewCell) {
		logic?.backButtonPressed()
	}

	func rightButtonPressed(onNavigationViewCell navigationViewCell: NavigationViewCell) {
		logic?.speakButtonPressed()
	}
}
