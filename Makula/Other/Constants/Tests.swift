extension Const {
	/// Arguments passed on app start when targeting tests.
	struct TestArgument {
		/// A string appended to the app start arguments to indicate that the app is under UI test and thus any persisted states have to be cleared.
		static let testMode = "--testMode"

		/// Defines a specific setting scenario for testing.
		/// Needs to be added in conjunction with `testMode` and in disjunction with any setting states.
		enum Scenario: String {
			/// No specific scenario, but still in test mode.
			case none = ""
			/// User has started the app once to accept the disclaimer, but didn't do anything else.
			case startedOnce = "--startedOnce"
			/// User has used the app so some data is already provided by the user.
			case appUsed = "--appUsed"
			/// Some data to show on screenshots.
			case screenshots = "--screenshots"

			/**
			 Retrieves the scenario provided by the command line arguments if the `testMode` flag is set and a debug build is used.
			 If multiple scenarios are provided one at random is taken.

			 - parameter commandLineArguments: The command line arguments passed to the app which might include a scenario.
			 */
			init?(commandLineArguments: [String]?) {
				#if DEBUG
					guard let commandLineArguments = commandLineArguments, commandLineArguments.contains(Const.TestArgument.testMode) else {
						return nil
					}

					if commandLineArguments.contains(Scenario.startedOnce.rawValue) {
						self = .startedOnce
					} else if commandLineArguments.contains(Scenario.appUsed.rawValue) {
						self = .appUsed
					} else if commandLineArguments.contains(Scenario.screenshots.rawValue) {
						self = .screenshots
					} else {
						self = .none
					}
				#else
					return nil
				#endif
			}
		}
	}
}
