// The main models for display, logic and router.

/// The different models to pass to the logic. Nest structs for different models.
struct DisclaimerLogicModel {
	/// The current content state in the logic.
	struct ContentData {
		/// The global dependencies.
		var globalData: GlobalData?
		/// Whether the disclaimer has been confirmed with checking the checkbox or not in which case the checkbox should be un-checked (default).
		var disclaimerConfirmed = false
	}
}

/// The different models to pass to the display. Nest structs for different models.
struct DisclaimerDisplayModel {
	/// The model for updating the display.
	struct UpdateDisplay {
		/// Whether the display should use a large style, e.g. for landscape or not in which case the default style is used, e.g. portrait.
		let largeStyle: Bool
	}
}

/// The parameters to pass when routing.
struct DisclaimerRouterModel {
	/// The model for setup this scene.
	struct Setup {
		/// The global dependencies.
		let globalData: GlobalData
	}
}
