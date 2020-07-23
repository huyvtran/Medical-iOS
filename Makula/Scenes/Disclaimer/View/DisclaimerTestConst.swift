extension Const {
	/// Consts for testing the scene.
	struct DisclaimerTests {
		/// Accessibility identifier for views.
		struct ViewName {
			/// The scene's main view.
			static let mainView = "DisclaimerView"
			/// The confirm button.
			static let confirmButton = mainView + "ConfirmButton"
			/// The scroll view.
			static let scrollView = mainView + "ScrollView"
			/// The scroll view's content view.
			static let scrollContentView = mainView + "ScrollContentView"
			/// The checkbox button.
			static let checkbox = mainView + "Checkbox"
		}
	}
}
