@testable import Makula
import XCTest

/// A testing mock for when something depends on `NewAppointmentLogicInterface`.
class NewAppointmentLogicMock: BaseMock, NewAppointmentLogicInterface {
	// MARK: -

	var setModelStub: (_ model: NewAppointmentRouterModel.Setup) -> Void = { _ in BaseMock.fail() }

	func setModel(_ model: NewAppointmentRouterModel.Setup) {
		setModelStub(model)
	}

	// MARK: -

	var setSpeechDataStub: (_ data: [SpeechData]) -> Void = { _ in BaseMock.fail() }

	func setSpeechData(data: [SpeechData]) {
		setSpeechDataStub(data)
	}

	// MARK: -

	var requestDisplayDataStub: () -> Void = { BaseMock.fail() }

	func requestDisplayData() {
		requestDisplayDataStub()
	}

	// MARK: -

	var backButtonPressedStub: () -> Void = { BaseMock.fail() }

	func backButtonPressed() {
		backButtonPressedStub()
	}

	// MARK: -

	var speakButtonPressedStub: () -> Void = { BaseMock.fail() }

	func speakButtonPressed() {
		speakButtonPressedStub()
	}

	// MARK: -

	var routeToDatePickerStub: (_ appointment: AppointmentType) -> Void = { _ in BaseMock.fail() }

	func routeToDatePicker(appointment: AppointmentType) {
		routeToDatePickerStub(appointment)
	}
}
