import Foundation
@testable import Makula

/// A subclass for testing internal method calls of `InternalSettings`.
class InternalSettingsTester: InternalSettings {
	// MARK: -

	var settingsVersion1Stub: ((_ appUpdate: Bool) -> Void)?

	override func settingsVersion1(appUpdate: Bool) {
		if let stub = settingsVersion1Stub {
			stub(appUpdate)
		} else {
			super.settingsVersion1(appUpdate: appUpdate)
		}
	}
}
