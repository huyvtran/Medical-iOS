@testable import Makula
import XCTest

/// A testing mock for when something depends on `SplashDisplayInterface`.
class SplashDisplayMock: BaseMock, SplashDisplayInterface {
	// MARK: -

	var updateDisplayStub: (_ model: SplashDisplayModel.UpdateDisplay) -> Void = { _ in BaseMock.fail() }

	func updateDisplay(model: SplashDisplayModel.UpdateDisplay) {
		updateDisplayStub(model)
	}

	// MARK: -

	var showDatabaseErrorStub: () -> Void = { BaseMock.fail() }

	func showDatabaseError() {
		showDatabaseErrorStub()
	}
}
