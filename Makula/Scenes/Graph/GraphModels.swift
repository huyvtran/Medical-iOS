// The main models for display, logic and router.
import Foundation

/// The different models to pass to the logic. Nest structs for different models.
struct GraphLogicModel {
	/// The current content state in the logic.
	struct ContentData {
		/// The global dependencies.
		var globalData: GlobalData?
		/// The type of eye this scene represents.
		var eyeType: EyeType = .left
	}
}

/// The different models to pass to the display. Nest structs for different models.
struct GraphDisplayModel {
	/// The model for updating the display.
	struct UpdateDisplay {
		/// Whether the display should use a large style, e.g. for landscape or not in which case the default style is used, e.g. portrait.
		let largeStyle: Bool
		/// The type of eye this scene represents.
		let eyeType: EyeType
		/// The date of the last treatment appointment if available.
		let ivomDate: Date?
		/// The NHD models to show in the graph.
		let nhdModels: [NhdModel]
		/// The Visus models to show in the graph.
		let visusModels: [VisusModel]
	}
}

/// The parameters to pass when routing.
struct GraphRouterModel {
	/// The model for setup this scene.
	struct Setup {
		/// The global dependencies.
		let globalData: GlobalData
		/// Set to `true` when the display should modify the navigation stack to remove the input scene. `false` leaves it as it is.
		let modifyNavigationStack: Bool
		/// The type of eye this scene represents.
		let eyeType: EyeType
	}
}
