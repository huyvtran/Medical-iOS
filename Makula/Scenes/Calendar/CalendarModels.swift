// The main models for display, logic and router.
import Foundation

/// The different models to pass to the logic. Nest structs for different models.
struct CalendarLogicModel {
	/// The current content state in the logic.
	struct ContentData {
		/// The global dependencies.
		var globalData: GlobalData?
		/// The date to focus.
		var focusDate: Date?
	}
}

/// The different models to pass to the display. Nest structs for different models.
struct CalendarDisplayModel {
	/// The model for updating the display.
	struct UpdateDisplay {
		/// Whether the display should use a large style, e.g. for landscape or not in which case the default style is used, e.g. portrait.
		let largeStyle: Bool
		/// The date to focus.
		let focusDate: Date
		/// The model manager for the table controller.
		let dataModelManager: DataModelManagerInterface
	}
}

/// The parameters to pass when routing.
struct CalendarRouterModel {
	/// The model for setup this scene.
	struct Setup {
		/// The global dependencies.
		let globalData: GlobalData
		/// Set to `true` when the display should modify the navigation stack to remove the new appointment scene. `false` leaves it as it is.
		let modifyNavigationStack: Bool
		/// The date to focus. Uses the current date when nil.
		let focusDate: Date?
	}
}
