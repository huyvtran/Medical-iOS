@testable import Makula
import XCTest

/// A testing mock for when something depends on `DisclaimerRouterInterface`.
class DisclaimerRouterMock: BaseMock, DisclaimerRouterInterface {
	// MARK: -

	var routeToMenuStub: (_ model: MenuRouterModel.Setup) -> Void = { _ in BaseMock.fail() }

	func routeToMenu(model: MenuRouterModel.Setup) {
		routeToMenuStub(model)
	}
}
