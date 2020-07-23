extension Const {
	/// Test constants for the view.
	struct SplitCellViewTests {
		/// Accessibility identifier for views under test.
		struct ViewName {
			/// The `SplitCellView`.
			static let splitCellView = "SplitCellView"
			/// The left title button.
			static let leftTitle = splitCellView + "LeftTitle"
			/// The right title button.
			static let rightTitle = splitCellView + "RightTitle"
			/// The bottom horizontal separator view.
			static let horizontalSeparator = splitCellView + "Separator"
		}
	}
}
