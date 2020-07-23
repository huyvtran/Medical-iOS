@testable import Makula
import RealmSwift
import XCTest

class SplashLogicTests: TestCase {
	// MARK: - Setup

	/// The subject under test.
	var sut: SplashLogic!
	/// The mocked display.
	var display: SplashDisplayMock!
	/// The mocked router.
	var router: SplashRouterMock!
	/// The global data.
	var globalData: GlobalData!
	/// The internal settings mock.
	var internalSettings: InternalSettingsMock!
	/// The data model manager mock.
	var dataModelManager: DataModelManagerMock!
	/// The notification worker mock.
	var notificationWorker: NotificationWorkerMock!

	override func setUp() {
		super.setUp()

		internalSettings = InternalSettingsMock()
		dataModelManager = DataModelManagerMock()
		notificationWorker = NotificationWorkerMock()
		globalData = GlobalData(internalSettings: internalSettings, dataModelManager: dataModelManager, notificationWorker: notificationWorker)

		display = SplashDisplayMock()
		router = SplashRouterMock()
		sut = SplashLogic(display: display, router: router)
	}

	override func tearDown() {
		sut = nil
		display = nil
		router = nil
		globalData = nil
		internalSettings = nil
		dataModelManager = nil
		notificationWorker = nil
		super.tearDown()
	}

	// MARK: - Tests

	// MARK: setModel

	/// The content data gets set.
	func testContentDataSet() {
		// Content data should not be set, yet.

		// Test data.
		let commandLineArguments = [String]()
		let model = SplashRouterModel.Setup(globalData: globalData, commandLineArguments: commandLineArguments)

		// Method under test.
		sut.setModel(model)

		// Content data should now be set properly.
	}

	// MARK: requestDisplayData

	/// The display data for the scene in portrait.
	func testPortrait() {
		// Input data.
		let commandLineArguments = [String]()
		let model = SplashRouterModel.Setup(globalData: globalData, commandLineArguments: commandLineArguments)
		sut.setModel(model)

		// Expect the display gets updated.
		let displayUpdateExpectation = expectation(description: "displayUpdateExpectation")
		display.updateDisplayStub = { _ in
			displayUpdateExpectation.fulfill()
		}

		// Method under test.
		sut.requestDisplayData()

		// Assure expectations.
		waitForExpectations(timeout: 1.0)
	}

	// MARK: processForTransition

	/// The counter automatically triggers the routing to the home menu after some time.
	func testCounterTransitionToHomeMenu() {
		// Init sut.
		let commandLineArguments = [String]()
		let model = SplashRouterModel.Setup(globalData: globalData, commandLineArguments: commandLineArguments)
		sut.setModel(model)

		// Expect the settings gets updated.
		let internalSettingsUpdateExpectation = expectation(description: "internalSettingsUpdateExpectation")
		internalSettings.updateSettingsStub = { _ in
			internalSettingsUpdateExpectation.fulfill()
			return false
		}

		// Expect the data model manager is requested to touch the database.
		let dataModelManagerTouchDatabaseExpectation = expectation(description: "dataModelManagerTouchDatabaseExpectation")
		dataModelManager.touchDatabaseStub = { _, handler in
			dataModelManagerTouchDatabaseExpectation.fulfill()
			handler(.finished)
		}

		// Expect the settings get queried for the disclaimer acceptance.
		let settingsDisclaimerAcceptedGetValue = true
		let settingsDisclaimerAcceptedGetExpectation = expectation(description: "settingsDisclaimerAcceptedGetExpectation")
		guard let settings = globalData.internalSettings as? InternalSettingsMock else { XCTFail(); return }
		settings.disclaimerAcceptedGetStub = {
			settingsDisclaimerAcceptedGetExpectation.fulfill()
			return settingsDisclaimerAcceptedGetValue
		}

		// Expect local notifications setup.
		let setupLocalNotificationsExpectation = expectation(description: "setupLocalNotificationsExpectation")
		notificationWorker.setupLocalNotificationsStub = { _, _ in
			setupLocalNotificationsExpectation.fulfill()
		}

		// Expecting the router gets called to route to the home menu scene.
		let routerRouteToMenuExpectation = expectation(description: "routerRouteToMenuExpectation")
		router.routeToMenuStub = { model in
			XCTAssertEqual(model.sceneId, .home)
			routerRouteToMenuExpectation.fulfill()
		}

		// Method under test.
		sut.processForTransition()

		// Assure expectations.
		waitForExpectations(timeout: 5.0)
	}

	/// The counter automatically triggers the routing to the disclaimer scene after some time.
	func testCounterTransitionToDisclaimer() {
		// Init sut.
		let commandLineArguments = [String]()
		let model = SplashRouterModel.Setup(globalData: globalData, commandLineArguments: commandLineArguments)
		sut.setModel(model)

		// Expect the settings gets updated.
		let internalSettingsUpdateExpectation = expectation(description: "internalSettingsUpdateExpectation")
		internalSettings.updateSettingsStub = { _ in
			internalSettingsUpdateExpectation.fulfill()
			return false
		}

		// Expect the data model manager is requested to touch the database.
		let dataModelManagerTouchDatabaseExpectation = expectation(description: "dataModelManagerTouchDatabaseExpectation")
		dataModelManager.touchDatabaseStub = { _, handler in
			dataModelManagerTouchDatabaseExpectation.fulfill()
			handler(.finished)
		}

		// Expect the settings get queried for the disclaimer acceptance.
		let settingsDisclaimerAcceptedGetValue = false
		let settingsDisclaimerAcceptedGetExpectation = expectation(description: "settingsDisclaimerAcceptedGetExpectation")
		guard let settings = globalData.internalSettings as? InternalSettingsMock else { XCTFail(); return }
		settings.disclaimerAcceptedGetStub = {
			settingsDisclaimerAcceptedGetExpectation.fulfill()
			return settingsDisclaimerAcceptedGetValue
		}

		// Expect local notifications setup.
		let setupLocalNotificationsExpectation = expectation(description: "setupLocalNotificationsExpectation")
		notificationWorker.setupLocalNotificationsStub = { _, _ in
			setupLocalNotificationsExpectation.fulfill()
		}

		// Expecting the router gets called to route to the disclaimer scene.
		let routerRouteToDisclaimerExpectation = expectation(description: "routerRouteToDisclaimerExpectation")
		router.routeToDisclaimerStub = { _ in
			routerRouteToDisclaimerExpectation.fulfill()
		}

		// Method under test.
		sut.processForTransition()

		// Assure expectations.
		waitForExpectations(timeout: 5.0)
	}

	/// The display is informed about a database error.
	func testCounterTransitionDatabaseError() {
		// Init sut.
		let commandLineArguments = [String]()
		let model = SplashRouterModel.Setup(globalData: globalData, commandLineArguments: commandLineArguments)
		sut.setModel(model)

		// Expect the settings gets updated.
		let internalSettingsUpdateExpectation = expectation(description: "internalSettingsUpdateExpectation")
		internalSettings.updateSettingsStub = { _ in
			internalSettingsUpdateExpectation.fulfill()
			return false
		}

		// Expect the data model manager is requested to touch the database.
		let dataModelManagerTouchDatabaseExpectation = expectation(description: "dataModelManagerTouchDatabaseExpectation")
		dataModelManager.touchDatabaseStub = { _, handler in
			dataModelManagerTouchDatabaseExpectation.fulfill()
			handler(.initError)
		}

		// Expect the display gets informed to display the error.
		let displayShowErrorExpectation = expectation(description: "displayShowErrorExpectation")
		display.showDatabaseErrorStub = {
			displayShowErrorExpectation.fulfill()
		}

		// Method under test.
		sut.processForTransition()

		// Assure expectations.
		waitForExpectations(timeout: 5.0)
	}
}
