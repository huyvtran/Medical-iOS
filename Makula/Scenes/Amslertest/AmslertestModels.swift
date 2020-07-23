// The main models for display, logic and router.

/// The different models to pass to the logic. Nest structs for different models.
struct AmslertestLogicModel {
	/// The current content state in the logic.
	struct ContentData {
		/// The global dependencies.
		var globalData: GlobalData?
		/// The persisted model representation.
		var amslertestModel: AmslertestModel?
	}
}

/// The different models to pass to the display. Nest structs for different models.
struct AmslertestDisplayModel {
	/// The model for updating the display.
	struct UpdateDisplay {
		/// Whether the display should use a large style, e.g. for landscape or not in which case the default style is used, e.g. portrait.
		let largeStyle: Bool
		/// The amslertest model, nil when a database error occurred.
		let amslertestModel: AmslertestModel?
		/// The model manager for the table controller.
		let dataModelManager: DataModelManagerInterface
	}
}

/// The parameters to pass when routing.
struct AmslertestRouterModel {
	/// The model for setup this scene.
	struct Setup {
		/// The global dependencies.
		let globalData: GlobalData
	}
}
