import UIKit

extension Const {
	/// All view margins.
	struct Margin {
		/// The default margin for views which defines only the left and right with 22 points each.
		static let `default` = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 22)

		/// The margin for the cells.
		static let cell = Const.Margin.default.top(8).bottom(13)
	}
}
