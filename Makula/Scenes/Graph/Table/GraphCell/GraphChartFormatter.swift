import Foundation
import Timepiece

/// The formatter to format X axis double values into month names shown as X axis labels.
class XAxisFormatter: NumberFormatter {
	init(currentDate: Date) {
		self.currentDate = currentDate
		super.init()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func string(for obj: Any?) -> String? {
		guard let value = obj as? Double else { return nil }
		// Cap the day fraction, the int value is the month to substract from today's the next month.
		let monthSubstraction = Int(floor(value))
		let endDate = (currentDate.startOfMonth() + 1.month)!
		let monthDate = (endDate + monthSubstraction.months)!
		let monthNumber = monthDate.month
		let yearNumber = monthDate.year
		let monthString = R.string.graph.graphMonthNumberFormat(monthNumber)
		let yearString = String(String(yearNumber).suffix(2))
		return R.string.graph.graphXAxisLabelFormat(monthString, yearString)
	}

	/// The current date to use for calculating the axis range.
	private var currentDate: Date
}
