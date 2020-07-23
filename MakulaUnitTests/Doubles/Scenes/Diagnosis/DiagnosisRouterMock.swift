@testable import Makula
import XCTest

/// A testing mock for when something depends on `DiagnosisRouterInterface`.
class DiagnosisRouterMock: BaseMock, DiagnosisRouterInterface {
	// MARK: -

	var routeToInformationStub: (_ model: InfoRouterModel.Setup) -> Void = { _ in BaseMock.fail() }

	func routeToInformation(model: InfoRouterModel.Setup) {
		routeToInformationStub(model)
	}

	// MARK: -

	var routeBackStub: () -> Void = { BaseMock.fail() }

	func routeBack() {
		routeBackStub()
	}
}
