@testable import Makula
import XCTest

/// A testing mock for when something depends on `MenuLogicInterface`.
class MenuLogicMock: BaseMock, MenuLogicInterface {
	// MARK: -

	var setModelStub: (_ model: MenuRouterModel.Setup) -> Void = { _ in BaseMock.fail() }

	func setModel(_ model: MenuRouterModel.Setup) {
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

	var openNewsUrlStub: () -> Void = { BaseMock.fail() }

	func openNewsUrl() {
		openNewsUrlStub()
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

	var routeToMenuStub: (_ sceneId: SceneId) -> Void = { _ in BaseMock.fail() }

	func routeToMenu(sceneId: SceneId) {
		routeToMenuStub(sceneId)
	}

	// MARK: -

	var routeToNewAppointmentStub: () -> Void = { BaseMock.fail() }

	func routeToNewAppointment() {
		routeToNewAppointmentStub()
	}

	// MARK: -

	var routeToContactStub: () -> Void = { BaseMock.fail() }

	func routeToContact() {
		routeToContactStub()
	}

	// MARK: -

	var routeToMedicamentStub: () -> Void = { BaseMock.fail() }

	func routeToMedicament() {
		routeToMedicamentStub()
	}

	// MARK: -

	var routeToDiagnosisStub: () -> Void = { BaseMock.fail() }

	func routeToDiagnosis() {
		routeToDiagnosisStub()
	}

	// MARK: -

	var routeToVisusNhdInputStub: (_ type: VisusNhdType) -> Void = { _ in BaseMock.fail() }

	func routeToVisusNhdInput(type: VisusNhdType) {
		routeToVisusNhdInputStub(type)
	}

	// MARK: -

	var routeToCalendarStub: () -> Void = { BaseMock.fail() }

	func routeToCalendar() {
		routeToCalendarStub()
	}

	// MARK: -

	var routeToAmslertestStub: () -> Void = { BaseMock.fail() }

	func routeToAmslertest() {
		routeToAmslertestStub()
	}

	// MARK: -

	var routeToGraphStub: () -> Void = { BaseMock.fail() }

	func routeToGraph() {
		routeToGraphStub()
	}

	// MARK: -

	var routeToReadingTestStub: () -> Void = { BaseMock.fail() }

	func routeToReadingTest() {
		routeToReadingTestStub()
	}

	// MARK: -

	var routeToInfoStub: (_ type: InfoType) -> Void = { _ in BaseMock.fail() }

	func routeToInfo(infoType type: InfoType) {
		routeToInfoStub(type)
	}

	// MARK: -

	var routeToAppointmentDetailStub: (_ date: Date) -> Void = { _ in BaseMock.fail() }

	func routeToAppointmentDetail(date: Date) {
		routeToAppointmentDetailStub(date)
	}

	// MARK: -

	var routeToSearchStub: () -> Void = { BaseMock.fail() }

	func routeToSearch() {
		routeToSearchStub()
	}

	// MARK: -

	var routeToReminderStub: () -> Void = { BaseMock.fail() }

	func routeToReminder() {
		routeToReminderStub()
	}
}
