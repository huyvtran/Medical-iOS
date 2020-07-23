@testable import Makula
import XCTest

/// A testing mock for when something depends on `DisclaimerLogicInterface`.
class DisclaimerLogicMock: BaseMock, DisclaimerLogicInterface {
	// MARK: -

	var setModelStub: (_ model: DisclaimerRouterModel.Setup) -> Void = { _ in BaseMock.fail() }

	func setModel(_ model: DisclaimerRouterModel.Setup) {
		setModelStub(model)
	}

	// MARK: -

	var requestDisplayDataStub: () -> Void = { BaseMock.fail() }

	func requestDisplayData() {
		requestDisplayDataStub()
	}

	// MARK: -

	var confirmButtonPressedStub: () -> Void = { BaseMock.fail() }

	func confirmButtonPressed() {
		confirmButtonPressedStub()
	}

	// MARK: -

	var checkboxButtonStateChangedStub: (_ checked: Bool) -> Void = { _ in BaseMock.fail() }

	func checkboxButtonStateChanged(checked: Bool) {
		checkboxButtonStateChangedStub(checked)
	}
}
