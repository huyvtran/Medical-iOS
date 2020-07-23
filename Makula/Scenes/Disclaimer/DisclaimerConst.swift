import UIKit

extension Const {
	/// Any constants for this scene.
	struct Disclaimer {
		struct Margin {
			/// The margin for content.
			static let content = Const.Margin.default.top(22).bottom(22)
		}

		struct Size {
			/// The gap between text labels in the content view.
			static let contentGap: CGFloat = 37.0
		}
	}
}
