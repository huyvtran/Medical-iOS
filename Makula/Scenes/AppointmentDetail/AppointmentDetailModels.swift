import Foundation
import RealmSwift

// The main models for display, logic and router.

/// The different models to pass to the logic. Nest structs for different models.
struct AppointmentDetailLogicModel {
	/// The current content state in the logic.
	struct ContentData {
		/// The global dependencies.
		var globalData: GlobalData?
		/// The apointment date.
		var date: Date?
	}
}

/// The different models to pass to the display. Nest structs for different models.
struct AppointmentDetailDisplayModel {
	/// The model for updating the display.
	struct UpdateDisplay {
		/// Whether the display should use a large style, e.g. for landscape or not in which case the default style is used, e.g. portrait.
		let largeStyle: Bool
		/// The apointment date.
		let date: Date
		/// The model manager for the table controller.
		let dataModelManager: DataModelManagerInterface
		/// The nav title.
		let title: String
		/// The nav title's color.
		let titleColor: UIColor
	}
}

/// The parameters to pass when routing.
struct AppointmentDetailRouterModel {
	/// The model for setup this scene.
	struct Setup {
		/// The global dependencies.
		let globalData: GlobalData
		/// The apointment date.
		let date: Date
	}
}
