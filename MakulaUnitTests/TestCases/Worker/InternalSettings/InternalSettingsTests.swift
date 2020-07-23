@testable import Makula
import XCTest

class InternalSettingsTests: TestCase {
	// MARK: - Setup

	/// The settings object under test.
	var sut: InternalSettingsTester!
	/// Where the settings persist its data.
	var userDefaults: UserDefaultsMock!

	override func setUp() {
		super.setUp()

		userDefaults = UserDefaultsMock()
		sut = InternalSettingsTester(userDefaults: userDefaults)
	}

	override func tearDown() {
		sut = nil
		userDefaults = nil

		super.tearDown()
	}

	// MARK: - Tests

	// MARK: updateSettings

	/// The internal update method is not called when the settings has a current version number.
	func testUpdateNotNeeded() {
		// Fake persistent data.
		let settingsVersion = Const.InternalSettings.LatestVersionNumber
		userDefaults.integerForKeyStub = { key in
			switch key {
			case Const.InternalSettings.Key.SettingsVersion:
				return settingsVersion
			default:
				XCTFail()
				return 0
			}
		}

		// Execute method under test.
		sut.updateSettings()
	}

	/// The internal update methods get called for a fresh install.
	func testUpdateFrom0() {
		// Fake persistent data.
		let settingsVersion = 0
		userDefaults.integerForKeyStub = { key in
			switch key {
			case Const.InternalSettings.Key.SettingsVersion:
				return settingsVersion
			default:
				XCTFail()
				return 0
			}
		}

		// Expect settings version will be set to the bundle version.
		let settingsVersionSetExpectation = expectation(description: "settingsVersionSetExpectation")
		userDefaults.setIntStub = { value, key in
			switch key {
			case Const.InternalSettings.Key.SettingsVersion:
				XCTAssertEqual(Const.InternalSettings.LatestVersionNumber, value)
				settingsVersionSetExpectation.fulfill()
			default:
				XCTFail()
			}
		}

		// Expect the internal update methods are called.
		let settingsVersion1Expectation = expectation(description: "settingsVersion1Expectation")
		sut.settingsVersion1Stub = { appUpdate in
			XCTAssertFalse(appUpdate)
			settingsVersion1Expectation.fulfill()
		}

		// Execute method under test.
		sut.updateSettings()

		// Wait for all expectations.
		waitForExpectations(timeout: 1.0)
	}

	// MARK: settingsVersion

	// The value is retrieved by the user defaults.
	func testSettingsVersionGet() {
		// Expected result data.
		let settingsVersion = 1

		// Expect the user defaults key accessor is called.
		let userDefaultsExpectation = expectation(description: "userDefaultsExpectation")
		userDefaults.integerForKeyStub = { key in
			if key == Const.InternalSettings.Key.SettingsVersion {
				userDefaultsExpectation.fulfill()
				return settingsVersion
			} else {
				XCTFail()
				return 0
			}
		}

		// Method under test.
		let result = sut.settingsVersion

		// Assure expectations.
		waitForExpectations(timeout: 1.0)

		// Result should match input.
		XCTAssertEqual(settingsVersion, result)
	}

	// The value is saved to the user defaults.
	func testSettingsVersionSet() {
		// Data to save.
		let settingsVersion = 1

		// Expect the user defaults key setter is called.
		let userDefaultsExpectation = expectation(description: "settingsVersionuserDefaultsExpectationSetExpectation")
		userDefaults.setIntStub = { value, key in
			if key == Const.InternalSettings.Key.SettingsVersion {
				XCTAssertEqual(settingsVersion, value)
				userDefaultsExpectation.fulfill()
			} else {
				XCTFail()
			}
		}

		// Method under test.
		sut.settingsVersion = settingsVersion

		// Assure expectations.
		waitForExpectations(timeout: 1.0)
	}

	// MARK: disclaimerAccepted

	// The value is retrieved by the user defaults.
	func testDisclaimerAcceptedGet() {
		// Expected result data.
		let disclaimerAccepted = true

		// Expect the user defaults key accessor is called.
		let userDefaultsExpectation = expectation(description: "userDefaultsExpectation")
		userDefaults.boolForKeyStub = { key in
			if key == Const.InternalSettings.Key.DisclaimerAccepted {
				userDefaultsExpectation.fulfill()
				return disclaimerAccepted
			} else {
				XCTFail()
				return false
			}
		}

		// Method under test.
		let result = sut.disclaimerAccepted

		// Assure expectations.
		waitForExpectations(timeout: 1.0)

		// Result should match input.
		XCTAssertEqual(disclaimerAccepted, result)
	}

	// The value is saved to the user defaults.
	func testDisclaimerAcceptedSet() {
		// Data to save.
		let disclaimerAccepted = true

		// Expect the user defaults key setter is called.
		let userDefaultsExpectation = expectation(description: "userDefaultsExpectation")
		userDefaults.setBoolStub = { value, key in
			if key == Const.InternalSettings.Key.DisclaimerAccepted {
				XCTAssertEqual(disclaimerAccepted, value)
				userDefaultsExpectation.fulfill()
			} else {
				XCTFail()
			}
		}

		// Method under test.
		sut.disclaimerAccepted = disclaimerAccepted

		// Assure expectations.
		waitForExpectations(timeout: 1.0)
	}

	// MARK: - Internal methods

	// MARK: settingsVersion1

	/// All properties are set for settings version 1 on a fresh install.
	func testSettingsVersion1Fresh() {
		// Expect the user defaults key setter is called.
		let disclaimerAcceptedExpectation = expectation(description: "disclaimerAccepted")
		let reminderOnExpectation = expectation(description: "reminderOn")
		userDefaults.setBoolStub = { value, key in
			switch key {
			case Const.InternalSettings.Key.DisclaimerAccepted:
				XCTAssertFalse(value)
				disclaimerAcceptedExpectation.fulfill()
			case Const.InternalSettings.Key.AppointmentReminder:
				XCTAssertFalse(value)
				reminderOnExpectation.fulfill()
			default:
				XCTFail()
			}
		}

		let reminderTimeExpectation = expectation(description: "reminderTime")
		userDefaults.setIntStub = { value, key in
			switch key {
			case Const.InternalSettings.Key.AppointmentReminderTime:
				XCTAssertEqual(0, value)
				reminderTimeExpectation.fulfill()
			default:
				XCTFail()
			}
		}

		// Method under test.
		sut.settingsVersion1(appUpdate: false)

		// Assure expectations.
		waitForExpectations(timeout: 1.0)
	}

	/// All properties are set for settings version 1 on an update.
	func testSettingsVersion1Update() {
		// Nothing to test, because this state is not defined.
	}
}
