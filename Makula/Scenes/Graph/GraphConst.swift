import UIKit

extension Const {
	/// Any constants for this scene.
	struct Graph {
		struct Value {
			/// The number of steps to show on the Y axis.
			static let yAxisSteps: Double = 12
			/// The number of steps to show on the X axis which represents how many months should be shown.
			static let xAxisSteps: Double = 24
			/// The number of months to show at once horizontally.
			static let xAxisStepsPerPage: Double = 3
			/// The factor to use for scaling the dots compared to the normal line width.
			static let dotFactor: Double = 2
		}
	}
}
