@testable import Makula
import XCTest

/// A testing mock for when something depends on `MenuRouterInterface`.
class MenuRouterMock: BaseMock, MenuRouterInterface {
	// MARK: -

	var routeToMenuStub: (_ model: MenuRouterModel.Setup) -> Void = { _ in BaseMock.fail() }

	func routeToMenu(model: MenuRouterModel.Setup) {
		routeToMenuStub(model)
	}

	// MARK: -

	var routeBackToMenuStub: () -> Void = { BaseMock.fail() }

	func routeBackToMenu() {
		routeBackToMenuStub()
	}

	// MARK: -

	var routeToNewAppointmentStub: (_ model: NewAppointmentRouterModel.Setup) -> Void = { _ in BaseMock.fail() }

	func routeToNewAppointment(model: NewAppointmentRouterModel.Setup) {
		routeToNewAppointmentStub(model)
	}

	// MARK: -

	var routeToContactStub: (_ model: ContactRouterModel.Setup) -> Void = { _ in BaseMock.fail() }

	func routeToContact(model: ContactRouterModel.Setup) {
		routeToContactStub(model)
	}

	// MARK: -

	var routeToDiagnosisStub: (_ model: DiagnosisRouterModel.Setup) -> Void = { _ in BaseMock.fail() }

	func routeToDiagnosis(model: DiagnosisRouterModel.Setup) {
		routeToDiagnosisStub(model)
	}

	// MARK: -

	var routeToMedicamentStub: (_ model: MedicamentRouterModel.Setup) -> Void = { _ in BaseMock.fail() }

	func routeToMedicament(model: MedicamentRouterModel.Setup) {
		routeToMedicamentStub(model)
	}

	// MARK: -

	var routeToVisusNhdInputStub: (_ model: VisusNhdInputRouterModel.Setup) -> Void = { _ in BaseMock.fail() }

	func routeToVisusNhdInput(model: VisusNhdInputRouterModel.Setup) {
		routeToVisusNhdInputStub(model)
	}

	// MARK: -

	var routeToCalendarStub: (_ model: CalendarRouterModel.Setup) -> Void = { _ in BaseMock.fail() }

	func routeToCalendar(model: CalendarRouterModel.Setup) {
		routeToCalendarStub(model)
	}

	// MARK: -

	var routeToAmslertestStub: (_ model: AmslertestRouterModel.Setup) -> Void = { _ in BaseMock.fail() }

	func routeToAmslertest(model: AmslertestRouterModel.Setup) {
		routeToAmslertestStub(model)
	}

	// MARK: -

	var routeToGraphStub: (_ model: GraphRouterModel.Setup) -> Void = { _ in BaseMock.fail() }

	func routeToGraph(model: GraphRouterModel.Setup) {
		routeToGraphStub(model)
	}

	// MARK: -

	var routeToReadingTestStub: (_ model: ReadingTestRouterModel.Setup) -> Void = { _ in BaseMock.fail() }

	func routeToReadingTest(model: ReadingTestRouterModel.Setup) {
		routeToReadingTestStub(model)
	}

	// MARK: -

	var routeToInfoStub: (_ model: InfoRouterModel.Setup) -> Void = { _ in BaseMock.fail() }

	func routeToInfo(model: InfoRouterModel.Setup) {
		routeToInfoStub(model)
	}

	// MARK: -

	var routeToAppointmentDetailStub: (_ model: AppointmentDetailRouterModel.Setup) -> Void = { _ in BaseMock.fail() }

	func routeToAppointmentDetail(model: AppointmentDetailRouterModel.Setup) {
		routeToAppointmentDetailStub(model)
	}

	// MARK: -

	var routeToInformationStub: (_ model: InfoRouterModel.Setup) -> Void = { _ in BaseMock.fail() }

	func routeToInformation(model: InfoRouterModel.Setup) {
		routeToInformationStub(model)
	}

	// MARK: -

	var routeToSearchStub: (_ model: SearchRouterModel.Setup) -> Void = { _ in BaseMock.fail() }

	func routeToSearch(model: SearchRouterModel.Setup) {
		routeToSearchStub(model)
	}

	// MARK: -

	var routeToReminderStub: (_ model: ReminderRouterModel.Setup) -> Void = { _ in BaseMock.fail() }

	func routeToReminder(model: ReminderRouterModel.Setup) {
		routeToReminderStub(model)
	}
}
