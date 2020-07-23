@testable import Makula
import XCTest

/// A testing mock for when something depends on `AppointmentDatePickerDisplayInterface`.
class AppointmentDatePickerDisplayMock: BaseMock, AppointmentDatePickerDisplayInterface {
	// MARK: -

	var updateDisplayStub: (_ model: AppointmentDatePickerDisplayModel.UpdateDisplay) -> Void = { _ in BaseMock.fail() }

	func updateDisplay(model: AppointmentDatePickerDisplayModel.UpdateDisplay) {
		updateDisplayStub(model)
	}

	// MARK: -

	var updatePickerDateStub: (_ model: AppointmentDatePickerDisplayModel.PickerDate) -> Void = { _ in BaseMock.fail() }

	func updatePickerDate(model: AppointmentDatePickerDisplayModel.PickerDate) {
		updatePickerDateStub(model)
	}

	// MARK: -

	var getAppointmentDateStub: () -> Date = { BaseMock.fail(); return Date() }

	func getAppointmentDate() -> Date {
		return getAppointmentDateStub()
	}

	// MARK: -

	var setAppointmentDateStub: (_ date: Date) -> Void = { _ in BaseMock.fail() }

	func setAppointmentDate(date: Date) {
		setAppointmentDateStub(date)
	}

	// MARK: -

	var showDatabaseWriteErrorStub: () -> Void = { BaseMock.fail() }

	func showDatabaseWriteError() {
		showDatabaseWriteErrorStub()
	}
}
