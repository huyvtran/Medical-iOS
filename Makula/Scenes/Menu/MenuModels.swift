// The main models for display, logic and router.

/// The different models to pass to the logic. Nest structs for different models.
struct MenuLogicModel {
	/// The current content state in the logic.
	struct ContentData {
		/// The global dependencies.
		var globalData: GlobalData?
		/// The ID of this menu scene.
		var sceneId: SceneId?
	}
}

/// The different models to pass to the display. Nest structs for different models.
struct MenuDisplayModel {
	/// The model for updating the display.
	struct UpdateDisplay {
		/// Whether this scene represents the menu's root or a sub-view.
		let isRoot: Bool
		/// Whether the display should use a large style, e.g. for landscape or not in which case the default style is used, e.g. portrait.
		let largeStyle: Bool
		/// The scene ID of this menu scene to differentiate the content to display.
		let sceneId: SceneId
		/// The model manager for the table controller.
		let dataModelManager: DataModelManagerInterface
	}
}

/// The parameters to pass when routing.
struct MenuRouterModel {
	/// The model for setup this scene.
	struct Setup {
		/// The global dependencies.
		let globalData: GlobalData
		/// The ID for this menu scene.
		let sceneId: SceneId
	}
}
