import UIKit

/// The model for the `CalendarWeekCell`.
struct CalendarWeekCellModel {
	/// When true the cell uses a large style for text and buttons (e.g. for landscape mode),
	/// while false uses the default style (e.g. for portrait).
	let largeStyle: Bool
	/// The week's date for passing back when tapping a day.
	let date: Date
	/// The text for the Monday label.
	let monText: String?
	/// The Monday label's text color. Nil to use the default.
	let monColor: UIColor?
	/// The text for the Tuesday label.
	let tueText: String?
	/// The Tuesday label's text color. Nil to use the default.
	let tueColor: UIColor?
	/// The text for the Wednesday label.
	let wedText: String?
	/// The Wednesday label's text color. Nil to use the default.
	let wedColor: UIColor?
	/// The text for the Thursday label.
	let thuText: String?
	/// The Thursday label's text color. Nil to use the default.
	let thuColor: UIColor?
	/// The text for the Friday label.
	let friText: String?
	/// The Friday label's text color. Nil to use the default.
	let friColor: UIColor?
	/// The text for the Saturday label.
	let satText: String?
	/// The Saturday label's text color. Nil to use the default.
	let satColor: UIColor?
	/// The text for the Sunday label.
	let sunText: String?
	/// The Sunday label's text color. Nil to use the default.
	let sunColor: UIColor?
	/// The delegate to inform about cell actions.
	weak var delegate: CalendarWeekCellDelegate?
}

/// The delegate protocol to inform about cell actions.
protocol CalendarWeekCellDelegate: class {
	/**
	 Informs that the picker's value has changed.

	 - parameter calendarWeekCell: The cell with the day button which got selected.
	 - parameter weekDate: The cell's week day date.
	 - parameter dayIndex: The day's index selected (0 = Monday, ..., 6 = Sunday).
	 */
	func daySelected(onCalendarWeekCell calendarWeekCell: CalendarWeekCell, weekDate: Date, dayIndex: Int)
}
