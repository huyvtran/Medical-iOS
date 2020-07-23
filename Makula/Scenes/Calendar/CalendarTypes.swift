// Any global types for this scene.

enum CalendarMonth: Int {
	case january = 1
	case february
	case march
	case april
	case may
	case june
	case july
	case august
	case september
	case october
	case november
	case december

	/**
	 Returns the printable representation of the month.

	 - returns: The month's localized name.
	 */
	func titleString() -> String {
		switch self {
		case .january:
			return R.string.calendar.monthJanuary()
		case .february:
			return R.string.calendar.monthFebruary()
		case .march:
			return R.string.calendar.monthMarch()
		case .april:
			return R.string.calendar.monthApril()
		case .may:
			return R.string.calendar.monthMay()
		case .june:
			return R.string.calendar.monthJune()
		case .july:
			return R.string.calendar.monthJuly()
		case .august:
			return R.string.calendar.monthAugust()
		case .september:
			return R.string.calendar.monthSeptember()
		case .october:
			return R.string.calendar.monthOctober()
		case .november:
			return R.string.calendar.monthNovember()
		case .december:
			return R.string.calendar.monthDecember()
		}
	}
}
