@testable import Makula
import XCTest

/// A testing mock for when something depends on `DisclaimerDisplayInterface`.
class DisclaimerDisplayMock: BaseMock, DisclaimerDisplayInterface {
	// MARK: -

	var updateDisplayStub: (_ model: DisclaimerDisplayModel.UpdateDisplay) -> Void = { _ in BaseMock.fail() }

	func updateDisplay(model: DisclaimerDisplayModel.UpdateDisplay) {
		updateDisplayStub(model)
	}

	// MARK: -

	var updateConfirmButtonStub: (_ enabled: Bool) -> Void = { _ in BaseMock.fail() }

	func updateConfirmButton(enabled: Bool) {
		updateConfirmButtonStub(enabled)
	}
}
