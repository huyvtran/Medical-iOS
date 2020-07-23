@testable import Makula
import XCTest

/// A testing mock for when something depends on `SplashRouterInterface`.
class SplashRouterMock: BaseMock, SplashRouterInterface {
	// MARK: -

	var routeToMenuStub: (_ model: MenuRouterModel.Setup) -> Void = { _ in BaseMock.fail() }

	func routeToMenu(model: MenuRouterModel.Setup) {
		routeToMenuStub(model)
	}

	// MARK: -

	var routeToDisclaimerStub: (_ model: DisclaimerRouterModel.Setup) -> Void = { _ in BaseMock.fail() }

	func routeToDisclaimer(model: DisclaimerRouterModel.Setup) {
		routeToDisclaimerStub(model)
	}
}
