// The main models for display, logic and router.

/// The different models to pass to the logic. Nest structs for different models.
struct SearchLogicModel {
	/// The current content state in the logic.
	struct ContentData {
		/// The global dependencies.
		var globalData: GlobalData?
		/// The search string to apply for the search.
		var searchString: String?
	}
}

/// The different models to pass to the display. Nest structs for different models.
struct SearchDisplayModel {
	/// The model for updating the display.
	struct UpdateDisplay {
		/// Whether the display should use a large style, e.g. for landscape or not in which case the default style is used, e.g. portrait.
		let largeStyle: Bool
		/// The search string to apply for the search.
		let searchString: String?
	}
}

/// The parameters to pass when routing.
struct SearchRouterModel {
	/// The model for setup this scene.
	struct Setup {
		/// The global dependencies.
		let globalData: GlobalData
	}
}
