import UIKit

extension Const {
	/// Any constants for this scene.
	struct Calendar {
		struct Margin {
			/// The margin for the week names view.
			static let weekNamesView = Const.Margin.default.top(18).bottom(13)
		}

		struct Value {
			/// The number of months to display in the calendar before the current month.
			static let monthBefore = 24
			/// The number of months to display in the calendar after the current month.
			static let monthsAfter = 24
		}
	}
}
