import RealmSwift
import UIKit

class AppointmentDetailTableController: NSObject {
	// MARK: - Properties

	/// The table view this controller manages.
	private let tableView: UITableView

	/// A reference to the logic to inform about cell actions.
	private weak var logic: AppointmentDetailLogicInterface?

	/// The model applied for display the content.
	private var displayModel: AppointmentDetailDisplayModel.UpdateDisplay?

	/// The appointment type currently displayed.
	private var appointmentType: AppointmentType = .other

	/// The time formatter to format the appointment's time.
	var timeFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = R.string.appointmentDetail.appointmentTimeFormat()
		return formatter
	}()

	// MARK: - Init

	/**
	 Sets up the controller with needed references.

	 - parameter tableView: The reference to the table view this controller should manage.
	 - parameter logic: The logic which becomes the delegate to inform about cell actions. Will not be retained.
	 */
	init(tableView: UITableView, logic: AppointmentDetailLogicInterface) {
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
		tableView.register(SplitRadioCell.self)
	}

	// MARK: - Table content

	/// The data representation for the table view.
	private var tableData = [AppointmentDetailTableData]()

	/**
	 Creates the data for the table view by mapping the `rawData` with the given display model.
	 Does not reload the table view itself.

	 - parameter model: The model to apply for displaying the content.
	 */
	private func createTableData(model: AppointmentDetailDisplayModel.UpdateDisplay) {
		// Clear data.
		tableData = [AppointmentDetailTableData]()

		// Add the navigation view as first cell on large style.
		if model.largeStyle {
			tableData.append(.navigation)
		}

		// Add the treatment appointment cells.
		if let cellData = appointmentCells(type: .treatment) {
			tableData += cellData
		}

		// Add visus/NHD introduction cell.
		if let cellData = nhdVisusHeaderCells() {
			tableData += cellData
		}

		// Add the visus cells.
		if let cellData = visusCells() {
			tableData += cellData
		}

		// Add the NHD cells.
		if let cellData = nhdCells() {
			tableData += cellData
		}

		// Add the aftercare appointment cells if it exists.
		if let cellData = appointmentCells(type: .aftercare) {
			tableData += cellData
		}

		// Add the oct-check appointment cells if it exists.
		if let cellData = appointmentCells(type: .octCheck) {
			tableData += cellData
		}

		// Add the other appointment cells if it exists.
		if let cellData = appointmentCells(type: .other) {
			tableData += cellData
		}

		// Add the amslertest cells if it exists.
		if let cellData = amslertestCells() {
			tableData += cellData
		}

		// Add the reading test cells if it exists.
		if let cellData = readingtestCells() {
			tableData += cellData
		}

		// Add the notes cell.
		tableData.append(AppointmentDetailTableData.note)

		// Add the delete cell.
		tableData.append(AppointmentDetailTableData.delete)

		// Creates the speech data.
		createSpeechData(model: model)
	}

	/**
	 Creates the speech data for the table view by mapping the `tableData` with the given display model.

	 - parameter model: The model to apply for displaying the content.
	 */
	private func createSpeechData(model: AppointmentDetailDisplayModel.UpdateDisplay) {
		// Use the table data to provide the speech data to the logic.
		var rowIndex = model.largeStyle ? 1 : 0
		var speechData = [SpeechData]()

		for data in tableData {
			let speechText: String
			switch data {
			case .navigation:
				continue
			case let .title(model):
				guard let modelSpeechText = model.speechTitle else { fatalError() }
				speechText = modelSpeechText
			case let .split(model):
				guard let modelSpeechText = model.speechText else { fatalError() }
				speechText = modelSpeechText
			case let .amslertestSplitRadio(_, type):
				speechText = type.titleSpeechText()
			case .note:
				speechText = R.string.appointmentDetail.noteCellTitleSpeech()
			case .delete:
				speechText = R.string.appointmentDetail.deleteCellTitleSpeech()
			}

			let indexPath = IndexPath(row: rowIndex, section: 0)
			let speech = SpeechData(text: speechText, indexPath: indexPath)
			speechData.append(speech)
			rowIndex += 1
		}

		logic?.setSpeechData(data: speechData)
	}

	// Make the cells for a specific appointment.
	private func appointmentCells(type: AppointmentType) -> [AppointmentDetailTableData]? {
		guard let displayModel = displayModel else { fatalError() }

		// Retrieve model from database.
		let results = displayModel.dataModelManager.getAppointmentModels(forDay: displayModel.date, type: type)
		guard let appointments = results, let appointment = appointments.first else {
			return nil
		}

		// The title cell.
		let titleCellData = AppointmentDetailTableData.title(
			StaticTextCellModel(
				accessibilityIdentifier: String.empty,
				title: type == .other ? R.string.appointmentDetail.medicalAppointmentCellTitle() : appointment.type.nameString(),
				speechTitle: type == .other ? R.string.appointmentDetail.medicalAppointmentCellTitle() : appointment.type.nameSpeechString(),
				largeFont: displayModel.largeStyle,
				defaultColor: appointment.type.defaultColor(),
				highlightColor: appointment.type.highlightColor(),
				backgroundColor: Const.Color.darkMain,
				separatorVisible: true,
				separatorDefaultColor: appointment.type.defaultColor(),
				separatorHighlightColor: appointment.type.defaultColor(),
				disabled: true,
				centeredText: false
			)
		)

		// The appointment's date.
		let timeString = R.string.appointmentDetail.appointmentTime(timeFormatter.string(from: appointment.date))
		let dateCellData = AppointmentDetailTableData.title(
			StaticTextCellModel(
				accessibilityIdentifier: String.empty,
				title: timeString,
				speechTitle: timeString,
				largeFont: displayModel.largeStyle,
				defaultColor: appointment.type.defaultColor(),
				highlightColor: appointment.type.highlightColor(),
				backgroundColor: Const.Color.darkMain,
				separatorVisible: true,
				separatorDefaultColor: appointment.type.defaultColor(),
				separatorHighlightColor: appointment.type.defaultColor(),
				disabled: true,
				centeredText: false
			)
		)

		return [titleCellData, dateCellData]
	}

	// Make the cells for the NHD/visis header.
	private func nhdVisusHeaderCells() -> [AppointmentDetailTableData]? {
		guard let displayModel = displayModel else { fatalError() }

		// Retrieve model from database.
		guard let visusResults = displayModel.dataModelManager.getVisusModels(forDay: displayModel.date) else { return nil }
		guard let nhdResults = displayModel.dataModelManager.getNhdModels(forDay: displayModel.date) else { return nil }
		if visusResults.count == 0 && nhdResults.count == 0 {
			return nil
		}

		let titleCellData = AppointmentDetailTableData.split(
			SplitCellModel(
				leftTitle: R.string.appointmentDetail.splitCellTitleLeft(),
				rightTitle: R.string.appointmentDetail.splitCellTitleRight(),
				speechText: R.string.appointmentDetail.splitCellTitleLeftSpeech() +
					R.string.global.speechSplitConnector() + R.string.appointmentDetail.splitCellTitleRightSpeech(),
				leftSelected: false,
				rightSelected: false,
				largeStyle: displayModel.largeStyle,
				disabled: true,
				backgroundColor: Const.Color.darkMain,
				separatorColor: Const.Color.lightMain,
				delegate: nil
			)
		)
		return [titleCellData]
	}

	// Make the cells for the visis model.
	private func visusCells() -> [AppointmentDetailTableData]? {
		guard let displayModel = displayModel else { fatalError() }

		// Retrieve model from database.
		let results = displayModel.dataModelManager.getVisusModels(forDay: displayModel.date)
		guard let entries = results, let visusModel = entries.first else {
			return nil
		}

		var cellData = [AppointmentDetailTableData]()

		// The title.
		let titleCellData = AppointmentDetailTableData.title(
			StaticTextCellModel(
				accessibilityIdentifier: String.empty,
				title: R.string.appointmentDetail.visusModelCellTitle(),
				speechTitle: R.string.appointmentDetail.visusModelCellTitleSpeech(),
				largeFont: displayModel.largeStyle,
				defaultColor: AppointmentType.treatment.defaultColor(),
				highlightColor: AppointmentType.treatment.highlightColor(),
				backgroundColor: Const.Color.darkMain,
				separatorVisible: true,
				separatorDefaultColor: AppointmentType.treatment.defaultColor(),
				separatorHighlightColor: AppointmentType.treatment.defaultColor(),
				disabled: true,
				centeredText: false
			)
		)
		cellData.append(titleCellData)

		// The value split cell.
		let leftTitle = VisusNhdType.visus.valueOutput(value: Float(visusModel.valueLeft))
		let rightTitle = VisusNhdType.visus.valueOutput(value: Float(visusModel.valueRight))
		let valueCellData = AppointmentDetailTableData.split(
			SplitCellModel(
				leftTitle: leftTitle,
				rightTitle: rightTitle,
				speechText: leftTitle + R.string.global.speechSplitConnector() + rightTitle,
				leftSelected: false,
				rightSelected: false,
				largeStyle: displayModel.largeStyle,
				disabled: true,
				backgroundColor: Const.Color.darkMain,
				separatorColor: Const.Color.lightMain,
				delegate: nil
			)
		)
		cellData.append(valueCellData)

		return cellData
	}

	// Make the cells for the NHD model.
	private func nhdCells() -> [AppointmentDetailTableData]? {
		guard let displayModel = displayModel else { fatalError() }

		// Retrieve model from database.
		let results = displayModel.dataModelManager.getNhdModels(forDay: displayModel.date)
		guard let entries = results, let nhdModel = entries.first else {
			return nil
		}

		var cellData = [AppointmentDetailTableData]()

		// The title.
		let titleCellData = AppointmentDetailTableData.title(
			StaticTextCellModel(
				accessibilityIdentifier: String.empty,
				title: R.string.appointmentDetail.nhdModelCellTitle(),
				speechTitle: R.string.appointmentDetail.nhdModelCellTitleSpeech(),
				largeFont: displayModel.largeStyle,
				defaultColor: AppointmentType.treatment.defaultColor(),
				highlightColor: AppointmentType.treatment.highlightColor(),
				backgroundColor: Const.Color.darkMain,
				separatorVisible: true,
				separatorDefaultColor: AppointmentType.treatment.defaultColor(),
				separatorHighlightColor: AppointmentType.treatment.defaultColor(),
				disabled: true,
				centeredText: false
			)
		)
		cellData.append(titleCellData)

		// The value split cell.
		let leftTitle = VisusNhdType.nhd.valueOutput(value: nhdModel.valueLeft)
		let rightTitle = VisusNhdType.nhd.valueOutput(value: nhdModel.valueRight)
		let valueCellData = AppointmentDetailTableData.split(
			SplitCellModel(
				leftTitle: leftTitle,
				rightTitle: rightTitle,
				speechText: leftTitle + R.string.global.speechSplitConnector() + rightTitle,
				leftSelected: false,
				rightSelected: false,
				largeStyle: displayModel.largeStyle,
				disabled: true,
				backgroundColor: Const.Color.darkMain,
				separatorColor: Const.Color.lightMain,
				delegate: nil
			)
		)
		cellData.append(valueCellData)

		return cellData
	}

	// Make the cells for the amslertest model.
	private func amslertestCells() -> [AppointmentDetailTableData]? {
		guard let displayModel = displayModel else { fatalError() }

		// Retrieve model from database.
		let results = displayModel.dataModelManager.getAmslertestModel(forDay: displayModel.date)
		guard let entries = results, let amslertestModel = entries.first else {
			return nil
		}

		var cellData = [AppointmentDetailTableData]()

		// The title cell.
		let titleCellData = AppointmentDetailTableData.title(
			StaticTextCellModel(
				accessibilityIdentifier: String.empty,
				title: R.string.appointmentDetail.amslertestModelCellTitle(),
				speechTitle: R.string.appointmentDetail.amslertestModelCellTitleSpeech(),
				largeFont: displayModel.largeStyle,
				defaultColor: Const.Color.lightMain,
				highlightColor: Const.Color.white,
				backgroundColor: Const.Color.darkMain,
				separatorVisible: true,
				separatorDefaultColor: Const.Color.lightMain,
				separatorHighlightColor: Const.Color.lightMain,
				disabled: true,
				centeredText: false
			)
		)
		cellData.append(titleCellData)

		// The left | right title.
		let splitCellData = AppointmentDetailTableData.split(
			SplitCellModel(
				leftTitle: R.string.appointmentDetail.splitCellTitleLeft(),
				rightTitle: R.string.appointmentDetail.splitCellTitleRight(),
				speechText: R.string.appointmentDetail.splitCellTitleLeftSpeech() +
					R.string.global.speechSplitConnector() + R.string.appointmentDetail.splitCellTitleRightSpeech(),
				leftSelected: false,
				rightSelected: false,
				largeStyle: displayModel.largeStyle,
				disabled: true,
				backgroundColor: Const.Color.darkMain,
				separatorColor: Const.Color.lightMain,
				delegate: nil
			)
		)
		cellData.append(splitCellData)

		// The progress cells.
		let progressTypeOrder: [AmslertestProgressType] = [.equal, .better, .worse]
		for progressType in progressTypeOrder {
			cellData.append(.amslertestSplitRadio(amslertestModel, progressType))
		}

		return cellData
	}

	// Make the cells for the readingtest model.
	private func readingtestCells() -> [AppointmentDetailTableData]? {
		guard let displayModel = displayModel else { fatalError() }

		// Retrieve model from database.
		let results = displayModel.dataModelManager.getReadingtestModel(forDay: displayModel.date)
		guard let entries = results, let readingtestModel = entries.first else {
			return nil
		}

		var cellData = [AppointmentDetailTableData]()

		// The title cell.
		let titleCellData = AppointmentDetailTableData.title(
			StaticTextCellModel(
				accessibilityIdentifier: String.empty,
				title: R.string.appointmentDetail.readingTestModelCellTitle(),
				speechTitle: R.string.appointmentDetail.readingTestModelCellTitleSpeech(),
				largeFont: displayModel.largeStyle,
				defaultColor: Const.Color.lightMain,
				highlightColor: Const.Color.white,
				backgroundColor: Const.Color.darkMain,
				separatorVisible: true,
				separatorDefaultColor: Const.Color.lightMain,
				separatorHighlightColor: Const.Color.lightMain,
				disabled: true,
				centeredText: false
			)
		)
		cellData.append(titleCellData)

		// The left | right title.
		let staticSplitCellData = AppointmentDetailTableData.split(
			SplitCellModel(
				leftTitle: R.string.appointmentDetail.splitCellTitleLeft(),
				rightTitle: R.string.appointmentDetail.splitCellTitleRight(),
				speechText: R.string.appointmentDetail.splitCellTitleLeftSpeech() +
					R.string.global.speechSplitConnector() + R.string.appointmentDetail.splitCellTitleRightSpeech(),
				leftSelected: false,
				rightSelected: false,
				largeStyle: displayModel.largeStyle,
				disabled: true,
				backgroundColor: Const.Color.darkMain,
				separatorColor: Const.Color.lightMain,
				delegate: nil
			)
		)
		cellData.append(staticSplitCellData)

		// The readingtest value.
		let leftTitle = String(readingtestModel.magnitudeLeft?.rawValue ?? 0)
		let rightTitle = String(readingtestModel.magnitudeRight?.rawValue ?? 0)
		let valueCellData = AppointmentDetailTableData.split(
			SplitCellModel(
				leftTitle: leftTitle,
				rightTitle: rightTitle,
				speechText: leftTitle + R.string.global.speechSplitConnector() + rightTitle,
				leftSelected: false,
				rightSelected: false,
				largeStyle: displayModel.largeStyle,
				disabled: true,
				backgroundColor: Const.Color.darkMain,
				separatorColor: Const.Color.lightMain,
				delegate: nil
			)
		)
		cellData.append(valueCellData)

		return cellData
	}
}

// MARK: - AppointmentDetailTableControllerInterface

extension AppointmentDetailTableController: AppointmentDetailTableControllerInterface {
	func setData(model: AppointmentDetailDisplayModel.UpdateDisplay) {
		displayModel = model
		let appointments = model.dataModelManager.getAppointmentModels(forDay: model.date)
		if let appointments = appointments, appointments.count == 1, let appointment = appointments.first {
			appointmentType = appointment.type
		} else {
			appointmentType = .other
		}

		createTableData(model: model)

		// Reload the content.
		tableView.reloadData()
		tableView.contentOffset = .zero
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

extension AppointmentDetailTableController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tableData.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let data = tableData[indexPath.row]
		switch data {
		case .navigation:
			return navigationViewCell()
		case let .title(model):
			return textCell(model: model)
		case let .split(model):
			return splitCell(model: model)
		case let .amslertestSplitRadio(model, progressType):
			return amslertestSplitRadioCell(model: model, progressType: progressType, indexPath: indexPath)
		case .note:
			return noteCell()
		case .delete:
			return deleteCell()
		}
	}

	// MARK: - Cells

	private func textCell(model: StaticTextCellModel) -> StaticTextCell {
		guard let cell = tableView.dequeueReusableCell(for: StaticTextCell.self) else { fatalError() }
		cell.setup(model: model)
		return cell
	}

	private func noteCell() -> StaticTextCell {
		guard let cell = tableView.dequeueReusableCell(for: StaticTextCell.self) else { fatalError() }
		guard let displayModel = displayModel else { fatalError() }

		let highlightColor = appointmentType == .other ? Const.Color.lightMain : Const.Color.white
		let cellModel = StaticTextCellModel(
			accessibilityIdentifier: String.empty,
			title: R.string.appointmentDetail.noteCellTitle(),
			speechTitle: R.string.appointmentDetail.noteCellTitleSpeech(),
			largeFont: displayModel.largeStyle,
			defaultColor: displayModel.titleColor,
			highlightColor: highlightColor,
			backgroundColor: Const.Color.darkMain,
			separatorVisible: true,
			separatorDefaultColor: displayModel.titleColor,
			separatorHighlightColor: displayModel.titleColor,
			disabled: false,
			centeredText: false
		)
		cell.setup(model: cellModel)
		return cell
	}

	private func deleteCell() -> StaticTextCell {
		guard let cell = tableView.dequeueReusableCell(for: StaticTextCell.self) else { fatalError() }
		guard let displayModel = displayModel else { fatalError() }

		let cellModel = StaticTextCellModel(
			accessibilityIdentifier: String.empty,
			title: R.string.appointmentDetail.deleteCellTitle(),
			speechTitle: R.string.appointmentDetail.deleteCellTitleSpeech(),
			largeFont: displayModel.largeStyle,
			defaultColor: Const.Color.magenta,
			highlightColor: Const.Color.white,
			backgroundColor: Const.Color.darkMain,
			separatorVisible: true,
			separatorDefaultColor: Const.Color.white,
			separatorHighlightColor: nil,
			disabled: false,
			centeredText: false
		)
		cell.setup(model: cellModel)
		return cell
	}

	private func splitCell(model: SplitCellModel) -> SplitCell {
		guard let cell = tableView.dequeueReusableCell(for: SplitCell.self) else { fatalError() }
		cell.setup(model: model)
		return cell
	}

	private func amslertestSplitRadioCell(model amslertestModel: AmslertestModel, progressType: AmslertestProgressType, indexPath: IndexPath) -> SplitRadioCell {
		guard let cell = tableView.dequeueReusableCell(for: SplitRadioCell.self) else { fatalError() }
		guard let displayModel = displayModel else { fatalError() }

		let cellModel = SplitRadioCellModel(
			indexPath: indexPath,
			title: progressType.titleText(),
			leftSelected: amslertestModel.progressLeft == progressType,
			rightSelected: amslertestModel.progressRight == progressType,
			largeStyle: displayModel.largeStyle,
			disabled: true,
			delegate: nil
		)
		cell.setup(model: cellModel)
		return cell
	}

	private func navigationViewCell() -> NavigationViewCell {
		guard let cell = tableView.dequeueReusableCell(for: NavigationViewCell.self) else {
			fatalError("No cell available")
		}
		guard let displayModel = displayModel else { fatalError() }

		let model = NavigationViewCellModel(
			title: displayModel.title,
			color: displayModel.titleColor,
			largeStyle: false,
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

extension AppointmentDetailTableController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		let data = tableData[indexPath.row]
		switch data {
		case .note:
			return indexPath
		case .delete:
			return indexPath
		default:
			return nil
		}
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		let data = tableData[indexPath.row]
		switch data {
		case .note:
			logic?.routeToNotes()
		case .delete:
			logic?.deletePressed()
		default:
			fatalError("Cell shouldn't be selectable")
		}
	}
}

// MARK: - NavigationViewCellDelegate

extension AppointmentDetailTableController: NavigationViewCellDelegate {
	func leftButtonPressed(onNavigationViewCell navigationViewCell: NavigationViewCell) {
		logic?.backButtonPressed()
	}

	func rightButtonPressed(onNavigationViewCell navigationViewCell: NavigationViewCell) {
		logic?.speakButtonPressed()
	}
}
