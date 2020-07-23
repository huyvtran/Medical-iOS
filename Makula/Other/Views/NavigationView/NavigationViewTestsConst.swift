extension Const {
	/// Test constants for the view.
	struct NavigationViewTests {
		/// Accessibility identifier for views under test.
		struct ViewName {
			/// The `NavigationView`.
			static let navigationView = "NavigationView"
			/// The title label.
			static let titleLabel = navigationView + "TitleLabel"
			/// The left button.
			static let leftButton = navigationView + "LeftButton"
			/// The right button.
			static let rightButton = navigationView + "RightButton"
			/// The separator view.
			static let separatorView = navigationView + "SeparatorView"
		}
	}
}
