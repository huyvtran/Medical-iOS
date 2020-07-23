import UIKit

class InternalSettings {
	// MARK: - Properties

	/// The user defaults to use by this settings.
	private let userDefaults: UserDefaults

	/// The standard UserDefaults to persist the app's internal settings to.
	private static let standardUserDefaults: () -> UserDefaults = {
		UserDefaults.standard
	}

	// MARK: - Init

	/**
	 Initializes the settings.

	 - parameter userDefaults: The user default object to use for persisting the app settings.
	 Defaultly the standard UserDefaults are used.
	 */
	init(userDefaults: UserDefaults = standardUserDefaults()) {
		self.userDefaults = userDefaults
	}

	// MARK: - Settings versions

	func settingsVersion1(appUpdate: Bool) {
		Log.info("v1")

		disclaimerAccepted = false
		reminderOn = false
		reminderTime = 0
	}

	// Add new settings version here...

	// MARK: - Test mode

	/**
	 Set up the internal settings for a test mode scenario.

	 See `Const.TestArgument` for possible arguments to pass via arguments.

	 - parameter testScenario: The test scenario to apply.
	 */
	func applyTestScenario(_ testScenario: Const.TestArgument.Scenario) {
		#if DEBUG
			// Delete app's persisted data.
			let domain = Bundle.main.bundleIdentifier!
			userDefaults.removePersistentDomain(forName: domain)
			userDefaults.synchronize()

			// Initialize settings with default values.
			updateSettings()

			// Set up settings according to scenario.
			switch testScenario {
			case .none:
				// No specific scenario.
				break
			case .startedOnce:
				testScenarioStartedOnce()
			case .screenshots:
				testScenarioScreenshots()
			case .appUsed:
				testScenarioAppUsed()
			}
		#else
			fatalError("'testMode' not supported in release version")
		#endif
	}

	// MARK: - Test scenarios

	#if DEBUG

		func testScenarioStartedOnce() {
			disclaimerAccepted = true
		}

		func testScenarioAppUsed() {
			disclaimerAccepted = true
		}

		func testScenarioScreenshots() {
			disclaimerAccepted = true
		}

		// Add new test scenarios here...

	#endif
}

// MARK: - SettingsInterface

extension InternalSettings: InternalSettingsInterface {
	@discardableResult func updateSettings(testScenario: Const.TestArgument.Scenario? = nil) -> Bool {
		if let testScenario = testScenario {
			applyTestScenario(testScenario)
			return false
		}

		// Not in test mode, try updating the settings.
		let currentSettingsVersion = settingsVersion
		guard currentSettingsVersion < Const.InternalSettings.LatestVersionNumber else {
			// Settings are up to date.
			return false
		}

		// Settings version needs to be updated.
		// `appUpdate` indicates that this isn't a fresh app install, but an app update
		// so some properties may have already been set.
		let appUpdate = currentSettingsVersion > 0
		Log.info("\(appUpdate ? "Updating" : "Initializing") internal settings")

		// Start updating for each version in case the user has skipped some updates.
		if currentSettingsVersion < Const.InternalSettings.SettingsVersion1 {
			settingsVersion1(appUpdate: appUpdate)
		}

		// Add new steps here...

		// Finish update.
		settingsVersion = Const.InternalSettings.LatestVersionNumber
		#if DEBUG
			// Force sync during development otherwise terminating the app in Xcode
			// may prevent the user defaults to persist just in time.
			userDefaults.synchronize()
		#endif
		Log.info("Internal settings updated")
		return true
	}

	var settingsVersion: Int {
		get {
			return userDefaults.integer(forKey: Const.InternalSettings.Key.SettingsVersion.rawValue)
		}
		set {
			userDefaults.set(newValue, forKey: Const.InternalSettings.Key.SettingsVersion.rawValue)
			NotificationCenter.default.post(name: Const.Notification.Name.InternalSettingsDidChange, object: self, userInfo:
				[Const.Notification.UserInfoKey.InternalSettingsDidChangeSettingKey: Const.InternalSettings.Key.SettingsVersion])
		}
	}

	var disclaimerAccepted: Bool {
		get {
			return userDefaults.bool(forKey: Const.InternalSettings.Key.DisclaimerAccepted.rawValue)
		}
		set {
			userDefaults.set(newValue, forKey: Const.InternalSettings.Key.DisclaimerAccepted.rawValue)
			NotificationCenter.default.post(name: Const.Notification.Name.InternalSettingsDidChange, object: self, userInfo:
				[Const.Notification.UserInfoKey.InternalSettingsDidChangeSettingKey: Const.InternalSettings.Key.DisclaimerAccepted])
		}
	}

	var reminderOn: Bool {
		get {
			return userDefaults.bool(forKey: Const.InternalSettings.Key.AppointmentReminder.rawValue)
		}
		set {
			userDefaults.set(newValue, forKey: Const.InternalSettings.Key.AppointmentReminder.rawValue)
			NotificationCenter.default.post(name: Const.Notification.Name.InternalSettingsDidChange, object: self, userInfo:
				[Const.Notification.UserInfoKey.InternalSettingsDidChangeSettingKey: Const.InternalSettings.Key.AppointmentReminder])
		}
	}

	var reminderTime: Int {
		get {
			return userDefaults.integer(forKey: Const.InternalSettings.Key.AppointmentReminderTime.rawValue)
		}
		set {
			userDefaults.set(newValue, forKey: Const.InternalSettings.Key.AppointmentReminderTime.rawValue)
			NotificationCenter.default.post(name: Const.Notification.Name.InternalSettingsDidChange, object: self, userInfo:
				[Const.Notification.UserInfoKey.InternalSettingsDidChangeSettingKey: Const.InternalSettings.Key.AppointmentReminderTime])
		}
	}
}
