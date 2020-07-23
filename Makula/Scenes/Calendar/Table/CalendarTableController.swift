import Timepiece
import UIKit

class CalendarTableController: NSObject {
	/// The calendar to use for date calculations.
	var calendar: () -> Calendar = {
		CommonDateFormatter.calendar
	}

	// MARK: - Properties

	/// The table view this controller manages.
	private let tableView: UITableView

	/// A reference to the logic to inform about cell actions.
	private weak var logic: CalendarLogicInterface?

	/// The model applied for display the content.
	private var displayModel: CalendarDisplayModel.UpdateDisplay?

	// MARK: - Init

	/**
	 Sets up the controller with needed references.

	 - parameter tableView: The reference to the table view this controller should manage.
	 - parameter logic: The logic which becomes the delegate to inform about cell actions. Will not be retained.
	 */
	init(tableView: UITableView, logic: CalendarLogicInterface) {
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
		tableView.showsVerticalScrollIndicator = false

		// Register cells
		tableView.register(CalendarMonthCell.self)
		tableView.register(CalendarWeekCell.self)
	}

	// MARK: - Table content

	/// The data representation for the table view.
	private var tableData = [[CalendarTableData]]()

	/**
	 Creates the data for the table view by mapping the `rawData` with the given display model.
	 Does not reload the table view itself.

	 - parameter model: The model to apply for displaying the content.
	 */
	private func createTableData(model: CalendarDisplayModel.UpdateDisplay) {
		// Clear data.
		tableData = [[CalendarTableData]]()

		// Current month's date.
		guard let currentMonth = Date().truncated(from: .hour)?.changed(day: 1) else { fatalError() }

		// Add the months before today.
		for diff in -Const.Calendar.Value.monthBefore ... -1 {
			guard let date = currentMonth + diff.months else { fatalError() }
			let section = tableDataSection(date: date)
			tableData.append(section)
		}

		// Add the current month.
		let section = tableDataSection(date: currentMonth)
		tableData.append(section)

		// Add the months after today.
		for diff in 1 ... Const.Calendar.Value.monthsAfter {
			guard let date = currentMonth + diff.months else { fatalError() }
			let section = tableDataSection(date: date)
			tableData.append(section)
		}
	}

	/**
	 Creates a whole section containing the month's name and the week cells for a given month date.

	 - parameter date: The month's date.
	 - returns: The table section for the date.
	 */
	private func tableDataSection(date: Date) -> [CalendarTableData] {
		var section = [CalendarTableData]()

		// Add month title cell.
		let monthValue = date.month
		let yearValue = date.year
		guard let month = CalendarMonth(rawValue: monthValue) else { fatalError() }
		let monthCellType = CalendarTableData.month(month, yearValue)
		section.append(monthCellType)

		// Append the week cells.
		let calendar = self.calendar()
		let firstOfMonth = date.startOfMonth(calendar: calendar)
		let lastOfMonth = date.endOfMonth(calendar: calendar)
		var weekDate = firstOfMonth
		while weekDate <= lastOfMonth {
			let weekCellType = CalendarTableData.week(weekDate)
			section.append(weekCellType)
			weekDate = (weekDate + 1.week) ?? lastOfMonth
		}
		// Append the last week, handled explicitly because of the calculation.
		let firstOfWeek = weekDate.startOfWeek(calendar: calendar)
		if firstOfWeek <= lastOfMonth {
			let weekCellType = CalendarTableData.week(lastOfMonth)
			section.append(weekCellType)
		}

		return section
	}

	/**
	 Returns the index path for a given date to show the month in the table view.

	 - parameter date: The date for which to determine its index path.
	 - returns: The corresponding index path.
	 */
	private func indexPathForDate(_ date: Date) -> IndexPath {
		let calendar = self.calendar()
		let currentMonth = Date().startOfMonth()
		let seekedMonth = date.startOfMonth()
		let monthDiffs = currentMonth.months(to: seekedMonth, calendar: calendar)
		let clampedMonths = max(-Const.Calendar.Value.monthBefore, min(Const.Calendar.Value.monthsAfter, monthDiffs))
		let section = Const.Calendar.Value.monthBefore + clampedMonths
		return IndexPath(row: 0, section: section)
	}
}

// MARK: - CalendarTableControllerInterface

extension CalendarTableController: CalendarTableControllerInterface {
	func setData(model: CalendarDisplayModel.UpdateDisplay) {
		displayModel = model
		createTableData(model: model)

		tableView.reloadData()

		// Focus day
		let indexPathToFocus = indexPathForDate(model.focusDate)
		DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
			self?.tableView.scrollToRow(at: indexPathToFocus, at: .top, animated: false)
		}
	}
}

// MARK: - UITableViewDataSource

extension CalendarTableController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return tableData.count
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tableData[section].count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let data = tableData[indexPath.section][indexPath.row]
		switch data {
		case let .month(month, year):
			return calendarMonthCell(month: month, year: year)
		case let .week(weekDate):
			return calendarWeekCell(weekDate: weekDate)
		}
	}

	// MARK: - Cells

	private func calendarMonthCell(month: CalendarMonth, year: Int) -> CalendarMonthCell {
		guard let cell = tableView.dequeueReusableCell(for: CalendarMonthCell.self) else { fatalError() }
		guard let largeStyle = displayModel?.largeStyle else { fatalError() }

		let title = R.string.calendar.monthTitleFormat(month.titleString(), String(year))
		let cellModel = CalendarMonthCellModel(largeStyle: largeStyle, title: title)
		cell.setup(model: cellModel)
		return cell
	}

	private func calendarWeekCell(weekDate: Date) -> CalendarWeekCell {
		guard let cell = tableView.dequeueReusableCell(for: CalendarWeekCell.self) else { fatalError() }
		guard let largeStyle = displayModel?.largeStyle else { fatalError() }
		guard let dataModelManager = displayModel?.dataModelManager else { fatalError() }
		let calendar = self.calendar()

		// Go through all days of the week.
		let firstOfWeek = weekDate.startOfWeek(calendar: calendar)
		var dayColors = [Int: UIColor]()
		var dayTexts = [Int: String]()
		for dayIndex in 0 ..< 7 {
			// Make sure the day's date is shown in the month's week cell.
			guard let dayDate = firstOfWeek + dayIndex.days else { fatalError() }
			let dayNumber = dayDate.day
			let shown = dayDate.isInSameMonth(date: weekDate, calendar: calendar)
			guard shown else { continue }

			// Save the day's number as text for the day label.
			dayTexts[dayIndex] = R.string.calendar.dayNumberFormat(dayNumber)

			// Determine the color for the day.
			guard let appointmentResults = dataModelManager.getAppointmentModels(forDay: dayDate) else { continue }
			if appointmentResults.count == 1 {
				// Single appointment, use the appointment's color.
				guard let appointment = appointmentResults.first else { fatalError() }
				dayColors[dayIndex] = appointment.type.defaultColor()
			} else if appointmentResults.count > 1 {
				// Multiple appointments.
				dayColors[dayIndex] = Const.Color.white
			} else {
				// No appointments, but maybe other data?
				guard let nhdResults = dataModelManager.getNhdModels(forDay: dayDate) else { continue }
				guard let visusResults = dataModelManager.getVisusModels(forDay: dayDate) else { continue }
				guard let readingtestResults = dataModelManager.getReadingtestModel(forDay: dayDate) else { continue }
				guard let amslertestResults = dataModelManager.getAmslertestModel(forDay: dayDate) else { continue }
				guard let noteResults = dataModelManager.getNoteModel(forDay: dayDate) else { continue }

				let noteContent = noteResults.first?.content ?? String.empty

				if nhdResults.count > 0 ||
					visusResults.count > 0 ||
					readingtestResults.count > 0 ||
					amslertestResults.count > 0 ||
					!noteContent.isEmpty {
					dayColors[dayIndex] = Const.Color.white
				}
			}
		}

		// Prepare cell.
		let cellModel = CalendarWeekCellModel(
			largeStyle: largeStyle,
			date: weekDate,
			monText: dayTexts[0],
			monColor: dayColors[0],
			tueText: dayTexts[1],
			tueColor: dayColors[1],
			wedText: dayTexts[2],
			wedColor: dayColors[2],
			thuText: dayTexts[3],
			thuColor: dayColors[3],
			friText: dayTexts[4],
			friColor: dayColors[4],
			satText: dayTexts[5],
			satColor: dayColors[5],
			sunText: dayTexts[6],
			sunColor: dayColors[6],
			delegate: self
		)
		cell.setup(model: cellModel)
		return cell
	}
}

// MARK: - UITableViewDelegate

extension CalendarTableController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		return nil
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
	}
}

// MARK: - NavigationViewCellDelegate

extension CalendarTableController: NavigationViewCellDelegate {
	func leftButtonPressed(onNavigationViewCell navigationViewCell: NavigationViewCell) {
		logic?.backButtonPressed()
	}

	func rightButtonPressed(onNavigationViewCell navigationViewCell: NavigationViewCell) {
		logic?.addButtonPressed()
	}
}

// MARK: - CalendarWeekCellDelegate

extension CalendarTableController: CalendarWeekCellDelegate {
	func daySelected(onCalendarWeekCell calendarWeekCell: CalendarWeekCell, weekDate: Date, dayIndex: Int) {
		let calendar = self.calendar()
		let firstOfWeek = weekDate.startOfWeek(calendar: calendar)
		guard let selectedDate = firstOfWeek + dayIndex.days else { fatalError() }
		guard selectedDate.isInSameMonth(date: weekDate) else {
			// Outside of this month, just skip action.
			return
		}
		logic?.daySelected(date: selectedDate)
	}
}
