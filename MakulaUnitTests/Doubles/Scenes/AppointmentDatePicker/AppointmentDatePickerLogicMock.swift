@testable import Makula
import XCTest

/// A testing mock for when something depends on `AppointmentDatePickerLogicInterface`.
class AppointmentDatePickerLogicMock: BaseMock, AppointmentDatePickerLogicInterface {
	// MARK: -

	var setModelStub: (_ model: AppointmentDatePickerRouterModel.Setup) -> Void = { _ in BaseMock.fail() }

	func setModel(_ model: AppointmentDatePickerRouterModel.Setup) {
		setModelStub(model)
	}

	// MARK: -

	var requestDisplayDataStub: () -> Void = { BaseMock.fail() }

	func requestDisplayData() {
		requestDisplayDataStub()
	}

	// MARK: -

	var databaseWriteErrorStub: () -> Void = { BaseMock.fail() }

	func databaseWriteError() {
		databaseWriteErrorStub()
	}

	// MARK: -

	var backButtonPressedStub: () -> Void = { BaseMock.fail() }

	func backButtonPressed() {
		backButtonPressedStub()
	}

	// MARK: -

	var saveButtonPressedStub: (_ date: Date) -> Void = { _ in BaseMock.fail() }

	func saveButtonPressed(withDate date: Date) {
		saveButtonPressedStub(date)
	}
}
