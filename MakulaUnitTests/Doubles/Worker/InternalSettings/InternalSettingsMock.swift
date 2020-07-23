@testable import Makula
import XCTest

/// A testing mock for when something depends on `InternalSettingsInterface`.
class InternalSettingsMock: BaseMock, InternalSettingsInterface {
	// MARK: -

	var updateSettingsStub: (_ testScenario: Const.TestArgument.Scenario?) -> Bool = { _ in BaseMock.fail(); return false }

	func updateSettings(testScenario: Const.TestArgument.Scenario?) -> Bool {
		return updateSettingsStub(testScenario)
	}

	// MARK: - Settings

	var settingsVersionGetStub: () -> Int = { BaseMock.fail(); return 0 }

	var settingsVersionSetStub: (_ value: Int) -> Void = { _ in BaseMock.fail() }

	var settingsVersion: Int {
		get {
			return settingsVersionGetStub()
		}
		set {
			settingsVersionSetStub(newValue)
		}
	}

	// MARK: -

	var disclaimerAcceptedGetStub: () -> Bool = { BaseMock.fail(); return false }

	var disclaimerAcceptedSetStub: (_ value: Bool) -> Void = { _ in BaseMock.fail() }

	var disclaimerAccepted: Bool {
		get {
			return disclaimerAcceptedGetStub()
		}
		set {
			disclaimerAcceptedSetStub(newValue)
		}
	}

	// MARK: -

	var reminderOnGetStub: () -> Bool = { BaseMock.fail(); return false }

	var reminderOnSetStub: (_ value: Bool) -> Void = { _ in BaseMock.fail() }

	var reminderOn: Bool {
		get {
			return reminderOnGetStub()
		}
		set {
			reminderOnSetStub(newValue)
		}
	}

	// MARK: -

	var reminderTimeGetStub: () -> Int = { BaseMock.fail(); return 0 }

	var reminderTimeSetStub: (_ value: Int) -> Void = { _ in BaseMock.fail() }

	var reminderTime: Int {
		get {
			return reminderTimeGetStub()
		}
		set {
			reminderTimeSetStub(newValue)
		}
	}
}
