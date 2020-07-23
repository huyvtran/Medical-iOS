@testable import Makula
import XCTest

/// A testing mock for when something depends on `SplashLogicInterface`.
class SplashLogicMock: BaseMock, SplashLogicInterface {
	// MARK: -

	var setModelStub: (_ model: SplashRouterModel.Setup) -> Void = { _ in BaseMock.fail() }

	func setModel(_ model: SplashRouterModel.Setup) {
		setModelStub(model)
	}

	// MARK: -

	var requestDisplayDataStub: () -> Void = { BaseMock.fail() }

	func requestDisplayData() {
		requestDisplayDataStub()
	}

	// MARK: -

	var processForTransitionStub: () -> Void = { BaseMock.fail() }

	func processForTransition() {
		processForTransitionStub()
	}
}
