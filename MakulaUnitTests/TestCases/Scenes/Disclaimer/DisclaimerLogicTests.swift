@testable import Makula
import XCTest

class DisclaimerLogicTests: TestCase {
	// MARK: - Setup

	/// The subject under test.
	var sut: DisclaimerLogic!
	/// The mocked display.
	var display: DisclaimerDisplayMock!
	/// The mocked router.
	var router: DisclaimerRouterMock!
	/// The simulated device orientation.
	var isDeviceOrientationLandscape = false
	/// The global data.
	var globalData: GlobalData!

	override func setUp() {
		super.setUp()

		let internalSettings = InternalSettingsMock()
		let dataModelManager = DataModelManagerMock()
		let notificationWorker = NotificationWorkerMock()
		globalData = GlobalData(internalSettings: internalSettings, dataModelManager: dataModelManager, notificationWorker: notificationWorker)

		display = DisclaimerDisplayMock()
		router = DisclaimerRouterMock()
		sut = DisclaimerLogic(display: display, router: router)
		isDeviceOrientationLandscape = false
		sut.isDeviceOrientationLandscape = { [unowned self] in self.isDeviceOrientationLandscape }
	}

	override func tearDown() {
		sut = nil
		display = nil
		router = nil
		globalData = nil
		super.tearDown()
	}

	// MARK: - Tests

	// MARK: setModel

	/// The content data gets set.
	func testContentDataSet() {
		// Content data should not be set, yet.

		// Test data.
		let model = DisclaimerRouterModel.Setup(globalData: globalData)

		// Method under test.
		sut.setModel(model)

		// Content data should now be set properly.
		XCTAssertFalse(sut.contentData.disclaimerConfirmed)
	}

	// MARK: requestDisplayData

	/// The display data for the scene in portrait.
	func testPortrait() {
		// Input data.
		let model = DisclaimerRouterModel.Setup(globalData: globalData)
		sut.setModel(model)
		isDeviceOrientationLandscape = false

		// Expect the display gets updated.
		let displayUpdateExpectation = expectation(description: "displayUpdateExpectation")
		display.updateDisplayStub = { model in
			XCTAssertFalse(model.largeStyle)
			displayUpdateExpectation.fulfill()
		}

		// Method under test.
		sut.requestDisplayData()

		// Assure expectations.
		waitForExpectations(timeout: 1.0)
	}

	/// The display data for the scene in landscape.
	func testLandscape() {
		// Input data.
		let model = DisclaimerRouterModel.Setup(globalData: globalData)
		sut.setModel(model)
		isDeviceOrientationLandscape = true

		// Expect the display gets updated.
		let displayUpdateExpectation = expectation(description: "displayUpdateExpectation")
		display.updateDisplayStub = { model in
			XCTAssertTrue(model.largeStyle)
			displayUpdateExpectation.fulfill()
		}

		// Method under test.
		sut.requestDisplayData()

		// Assure expectations.
		waitForExpectations(timeout: 1.0)
	}

	// MARK: confirmButtonPressed

	/// Confirm button press informs the router when the disclaimer has been confirmed.
	func testConfirmed() {
		// Prepare the content data.
		sut.contentData.globalData = globalData
		sut.contentData.disclaimerConfirmed = true

		// Test data.
		let sceneId = SceneId.home

		// Expect the router gets informed.
		let routerRouteMenuExpectation = expectation(description: "routerRouteMenuExpectation")
		router.routeToMenuStub = { model in
			XCTAssertEqual(sceneId, model.sceneId)
			routerRouteMenuExpectation.fulfill()
		}

		// Expect the settings get modified.
		let settingsChangedExpectation = expectation(description: "settingsChangedExpectation")
		guard let settings = globalData.internalSettings as? InternalSettingsMock else { XCTFail(); return }
		settings.disclaimerAcceptedSetStub = { flag in
			XCTAssertTrue(flag)
			settingsChangedExpectation.fulfill()
		}

		// Method under test.
		sut.confirmButtonPressed()

		// Assure expectation.
		waitForExpectations(timeout: 1.0)
	}

	/// Confirm button press does nothing when the disclaimer has not yet been confirmed.
	func testNotConfirmed() {
		// Prepare the content data.
		sut.contentData.globalData = globalData
		sut.contentData.disclaimerConfirmed = false

		// Method under test.
		sut.confirmButtonPressed()
	}

	// MARK: checkboxButtonStateChanged

	/// Setting the checkbox state updates the content data.
	func testCheckboxSelected() {
		// Prepare the content data.
		sut.contentData.globalData = globalData
		sut.contentData.disclaimerConfirmed = false

		// Test data.
		let checkboxChecked = true

		// Expect the display gets informed about the state change and display.
		let updateConfirmButtonExpectation = expectation(description: "updateConfirmButtonExpectation")
		display.updateConfirmButtonStub = { newState in
			XCTAssertEqual(checkboxChecked, newState)
			updateConfirmButtonExpectation.fulfill()
		}

		// Method under test.
		sut.checkboxButtonStateChanged(checked: checkboxChecked)

		// Assure expectations.
		waitForExpectations(timeout: 1.0)

		// Assure content data is updated.
		XCTAssertTrue(sut.contentData.disclaimerConfirmed)
	}

	/// Deselecting the checkbox state updates the content data and display.
	func testCheckboxDeselected() {
		// Prepare the content data.
		sut.contentData.globalData = globalData
		sut.contentData.disclaimerConfirmed = true

		// Test data.
		let checkboxChecked = false

		// Expect the display gets informed about the state change.
		let updateConfirmButtonExpectation = expectation(description: "updateConfirmButtonExpectation")
		display.updateConfirmButtonStub = { newState in
			XCTAssertEqual(checkboxChecked, newState)
			updateConfirmButtonExpectation.fulfill()
		}

		// Method under test.
		sut.checkboxButtonStateChanged(checked: checkboxChecked)

		// Assure expectations.
		waitForExpectations(timeout: 1.0)

		// Assure content data is updated.
		XCTAssertFalse(sut.contentData.disclaimerConfirmed)
	}
}
