@testable import Makula
import XCTest

/// A testing mock for when something depends on `NewAppointmentRouterInterface`.
class NewAppointmentRouterMock: BaseMock, NewAppointmentRouterInterface {
	// MARK: -

	var routeBackStub: () -> Void = { BaseMock.fail() }

	func routeBack() {
		routeBackStub()
	}

	// MARK: -

	var routeToDatePickerStub: (_ model: AppointmentDatePickerRouterModel.Setup) -> Void = { _ in BaseMock.fail() }

	func routeToDatePicker(model: AppointmentDatePickerRouterModel.Setup) {
		routeToDatePickerStub(model)
	}
}
