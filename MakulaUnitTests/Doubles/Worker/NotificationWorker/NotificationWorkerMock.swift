@testable import Makula
import XCTest

/// A testing mock for when something depends on `NotificationWorkerInterface`.
class NotificationWorkerMock: BaseMock, NotificationWorkerInterface {
	// MARK: -

	var authorizationRequestedStub: () -> Bool = { BaseMock.fail(); return false }

	var authorizationRequested: Bool { return authorizationRequestedStub() }

	// MARK: -

	var isAuthorizedStub: () -> Bool = { BaseMock.fail(); return false }

	var isAuthorized: Bool { return isAuthorizedStub() }

	// MARK: -

	var updateAuthorisationStatusStub: (_ completionHandler: @escaping (NotificationWorkerInterface) -> Void) -> Void = { _ in
		BaseMock.fail()
	}

	func updateAuthorisationStatus(completionHandler: @escaping (NotificationWorkerInterface) -> Void) {
		updateAuthorisationStatusStub(completionHandler)
	}

	// MARK: -

	var requestAuthorizationStub: (_ completionHandler: @escaping (NotificationWorkerInterface) -> Void) -> Void = {
		_ in
		BaseMock.fail()
	}

	func requestAuthorization(completionHandler: @escaping (NotificationWorkerInterface) -> Void) {
		requestAuthorizationStub(completionHandler)
	}

	// MARK: -

	var cancelAllNotificationRequestsStub: () -> Void = { BaseMock.fail() }

	func cancelAllNotificationRequests() {
		cancelAllNotificationRequestsStub()
	}

	// MARK: -

	var addNotificationStub: (_ identifier: String, _ title: String, _ message: String, _ date: Date) -> Void = {
		_, _, _, _ in
		BaseMock.fail()
	}

	func addNotification(identifier: String, title: String, message: String, date: Date) {
		addNotificationStub(identifier, title, message, date)
	}

	// MARK: -

	var setupLocalNotificationsStub: (_ internalSettings: InternalSettingsInterface,
	                                  _ dataModelManager: DataModelManagerInterface) -> Void = {
		_, _ in
		BaseMock.fail()
	}

	func setupLocalNotifications(internalSettings: InternalSettingsInterface, dataModelManager: DataModelManagerInterface) {
		setupLocalNotificationsStub(internalSettings, dataModelManager)
	}
}
