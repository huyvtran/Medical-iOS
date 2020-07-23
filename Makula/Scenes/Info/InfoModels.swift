// The main models for display, logic and router.

/// The different models to pass to the logic. Nest structs for different models.
struct InfoLogicModel {
	/// The current content state in the logic.
	struct ContentData {
		/// The global dependencies.
		var globalData: GlobalData?
		/// The scene type.
		var sceneType: InfoType?
		/// A running state for processing the bottom button, e.g. during backup.
		var processing = false
	}
}

/// The different models to pass to the display. Nest structs for different models.
struct InfoDisplayModel {
	/// The model for updating the display.
	struct UpdateDisplay {
		/// Whether the display should use a large style, e.g. for landscape or not in which case the default style is used, e.g. portrait.
		let largeStyle: Bool
		/// The scene type.
		let sceneType: InfoType
	}
}

/// The parameters to pass when routing.
struct InfoRouterModel {
	/// The model for setup this scene.
	struct Setup {
		/// The global dependencies.
		let globalData: GlobalData
		/// The scene type.
		let sceneType: InfoType
	}
}
