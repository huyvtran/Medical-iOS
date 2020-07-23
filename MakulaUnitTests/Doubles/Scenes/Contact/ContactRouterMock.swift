@testable import Makula
import XCTest

/// A testing mock for when something depends on `ContactRouterInterface`.
class ContactRouterMock: BaseMock, ContactRouterInterface {
	// MARK: -

	var routeBackToMenuStub: () -> Void = { BaseMock.fail() }

	func routeBackToMenu() {
		routeBackToMenuStub()
	}

	// MARK: -

	var routeToContactDetailsStub: (_ model: ContactDetailsRouterModel.Setup) -> Void = { _ in BaseMock.fail() }

	func routeToContactDetails(model: ContactDetailsRouterModel.Setup) {
		routeToContactDetailsStub(model)
	}
}
