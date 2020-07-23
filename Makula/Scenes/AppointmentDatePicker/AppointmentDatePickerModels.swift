// The main models for display, logic and router.
import Foundation

/// The different models to pass to the logic. Nest structs for different models.
struct AppointmentDatePickerLogicModel {
	/// The current content state in the logic.
	struct ContentData {
		/// The global dependencies.
		var globalData: GlobalData?
		/// The appointment type.
		var appointmentType: AppointmentType?
	}
}

/// The different models to pass to the display. Nest structs for different models.
struct AppointmentDatePickerDisplayModel {
	/// The model for updating the display.
	struct UpdateDisplay {
		/// Whether the display should use a large style, e.g. for landscape or not in which case the default style is used, e.g. portrait.
		let largeStyle: Bool
	}

	struct PickerDate {
		/// The date to set the picker with.
		let date: Date
	}
}

/// The parameters to pass when routing.
struct AppointmentDatePickerRouterModel {
	/// The model for setup this scene.
	struct Setup {
		/// The global dependencies.
		let globalData: GlobalData
		/// The appointment type.
		let appointmentType: AppointmentType
	}
}
