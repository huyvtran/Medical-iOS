// The main models for display, logic and router.

/// The different models to pass to the logic. Nest structs for different models.
struct SplashLogicModel {
	/// The current content state in the logic.
	struct ContentData {
		/// The global dependencies.
		var globalData: GlobalData?
		/// The command line arguments provided by the app launch.
		var commandLineArguments: [String]?
	}
}

/// The different models to pass to the display. Nest structs for different models.
struct SplashDisplayModel {
	/// The model for updating the display.
	struct UpdateDisplay {}
}

/// The parameters to pass when routing.
struct SplashRouterModel {
	/// The model for setup this scene.
	struct Setup {
		/// The global dependencies.
		let globalData: GlobalData
		/// The command line arguments provided by the app launch.
		var commandLineArguments: [String]
	}
}
