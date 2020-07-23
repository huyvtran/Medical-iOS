import Foundation

/// The diagnosis table cell representations.
enum CalendarTableData {
	/// The calendar month cell to show the month's title. First value is the month, the secodn the year.
	case month(CalendarMonth, Int)
	/// The calendar week cell representing a row of the month.
	case week(Date)
}
