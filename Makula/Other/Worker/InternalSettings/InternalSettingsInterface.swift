/**
 The app's internal settings which persists its properties and any app specific user changes between app starts.

 Everytime when a setting value has been altered a `InternalSettingsDidChange` notification will be send with a `userInfo` dict
 containing the changed setting's key as value for the user info's key `InternalSettingsDidChangeSettingType`.
 */
protocol InternalSettingsInterface: class {
	/**
	 Updates the internal settings with default values for not yet initialized properties
	 or according to the given command line arguments when in test mode.

	 This method has to be called after an app start so when the user starts the app the first time all setting properties get initialized properly.
	 Because when an app gets updated the app firstly gets terminated so the app delegate's `didFinishLaunchingWithOptions` method gets called
	 that would be the perfect place for calling this method.

	 If the arguments are provided and include the `testMode` argument and the app is running in debug mode
	 the other arguments related to the internal settings are interpreted,
	 which includes deleting any persisted data and pre-setting special test cases.
	 See `Const.TestArgument` for possible arguments to pass.

	 Otherwise the app is not in `testMode` and the properties are prepared for the normal app usage.
	 When new properties are introduced with an app update or something has changed, like new values for a property are added
	 then this method takes care of this.

	 The lastest version number can be seen with `Const.InternalSettings.LatestVersionNumber`.

	 - parameter testScenario: The test scenario to use when the app is in test mode.
	 - returns: `true` if an update has been performed, `false` when the settings were already up to date or the app is in test mode.
	 */
	@discardableResult func updateSettings(testScenario: Const.TestArgument.Scenario?) -> Bool

	/// The current setting's version.
	/// Returns 0 when none has been set.
	var settingsVersion: Int { get set }

	/// Whether the user has accepted the disclaimer or not.
	/// `true` if accepted, otherwise `false`.
	var disclaimerAccepted: Bool { get set }

	/// Wheter the user wants to get reminded of his appointments so local notifications are enabled or not.
	var reminderOn: Bool { get set }

	/// The time in minutes of a reminder for the appointments.
	var reminderTime: Int { get set }
}
