@testable import Makula
import XCTest

/// A testing mock for when something depends on `AppointmentDatePickerRouterInterface`.
class AppointmentDatePickerRouterMock: BaseMock, AppointmentDatePickerRouterInterface {
	// MARK: -

	var routeBackToNewAppointmentStub: () -> Void = { BaseMock.fail() }

	func routeBackToNewAppointment() {
		routeBackToNewAppointmentStub()
	}

	// MARK: -

	var routeToCalendarStub: (_ model: CalendarRouterModel.Setup) -> Void = { _ in BaseMock.fail() }

	func routeToCalendar(model: CalendarRouterModel.Setup) {
		routeToCalendarStub(model)
	}
}
