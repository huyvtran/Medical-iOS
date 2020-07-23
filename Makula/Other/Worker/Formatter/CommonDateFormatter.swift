import Foundation
import Timepiece

class CommonDateFormatter: DateFormatter {
	/// The gregorian calendar to use for time calculations, created only once because it's time intensive.
	static let calendar: Calendar = {
		var calendar = Calendar(identifier: .gregorian)
		calendar.locale = Locale.current
		calendar.minimumDaysInFirstWeek = 4 // ISO 8601 (non-US)
		calendar.firstWeekday = 2 // Monday (non-US)
		return calendar
	}()

	/**
	 Prints the date as `01.02.18`.

	 - parameter date: The date to format.
	 - returns: The formatted date.
	 */
	static func formattedString(date: Date) -> String {
		return date.string(withFormat: R.string.global.commonDateFormat(), calendar: calendar)
	}

	/**
	 Prints the date with the weekday prefix as `Mo 01.02.18`.

	 - parameter date: The date to format.
	 - returns: The formatted date.
	 */
	static func formattedStringWithWeekday(date: Date) -> String {
		let formattedDate = date.string(withFormat: R.string.global.commonDateFormat(), calendar: calendar)
		let weekday = date.weekday
		let weekdayString: String
		switch weekday {
		case 1:
			weekdayString = R.string.global.commonDateWeekdaySu()
		case 2:
			weekdayString = R.string.global.commonDateWeekdayMo()
		case 3:
			weekdayString = R.string.global.commonDateWeekdayTu()
		case 4:
			weekdayString = R.string.global.commonDateWeekdayWe()
		case 5:
			weekdayString = R.string.global.commonDateWeekdayTh()
		case 6:
			weekdayString = R.string.global.commonDateWeekdayFr()
		case 7:
			weekdayString = R.string.global.commonDateWeekdaySa()
		default:
			fatalError()
		}
		return R.string.global.commonDateWithWeekdayFormat(weekdayString, formattedDate)
	}

	/**
	 Prints the time as `08:15`.

	 - parameter date: The time to format.
	 - returns: The formatted date.
	 */
	static func formattedTimeString(date: Date) -> String {
		return date.string(withFormat: R.string.global.commonTimeFormat(), calendar: calendar)
	}
}
