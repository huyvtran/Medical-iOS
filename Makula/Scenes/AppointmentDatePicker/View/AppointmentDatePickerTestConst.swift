extension Const {
	/// Consts for testing the scene.
	struct AppointmentDatePickerTests {
		/// Accessibility identifier for views.
		struct ViewName {
			/// The scene's main view.
			static let mainView = "AppointmentDatePickerView"
			/// The save button.
			static let saveButton = mainView + "SaveButton"
			/// The scroll view.
			static let scrollView = mainView + "ScrollView"
			/// The scroll view's content view.
			static let scrollContentView = mainView + "ScrollContentView"
			/// The date picker.
			static let datePicker = mainView + "DatePicker"
		}
	}
}
