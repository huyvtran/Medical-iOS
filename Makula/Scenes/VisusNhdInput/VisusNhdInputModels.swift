// The main models for display, logic and router.

/// The different models to pass to the logic. Nest structs for different models.
struct VisusNhdInputLogicModel {
	/// The current content state in the logic.
	struct ContentData {
		/// The global dependencies.
		var globalData: GlobalData?
		/// The scene type.
		var sceneType: VisusNhdType?
		/// Whether the left side is selected.
		var leftSelected = false
		/// Whether the right side is selected.
		var rightSelected = false
		/// The value for the left eye.
		var leftValue: Float?
		/// The value for the right eye.
		var rightValue: Float?
	}
}

/// The different models to pass to the display. Nest structs for different models.
struct VisusNhdInputDisplayModel {
	/// The model for updating the display.
	struct UpdateDisplay {
		/// Whether the display should use a large style, e.g. for landscape or not in which case the default style is used, e.g. portrait.
		let largeStyle: Bool
		/// The scene type.
		let sceneType: VisusNhdType
		/// Whether the left side is selected.
		let leftSelected: Bool
		/// Whether the right side is selected.
		let rightSelected: Bool
		/// The value for the left side.
		let leftValue: Float?
		/// The value for the right side.
		let rightValue: Float?
	}

	/// The model for updating only the value title cell according to a new value in the logic.
	struct UpdateValueTitle {
		/// The value for the left side.
		let leftValue: Float?
		/// The value for the right side.
		let rightValue: Float?
	}
}

/// The parameters to pass when routing.
struct VisusNhdInputRouterModel {
	/// The model for setup this scene.
	struct Setup {
		/// The global dependencies.
		let globalData: GlobalData
		/// The scene type.
		let sceneType: VisusNhdType
	}
}
