import UIKit

/**
 The logic class of this scene.

 This class is responsible for any logic happening in the scene, all possible states and the data models.
 It is NOT responsible for any presentation, this is what the display is for.
 This class also doesn't need to provide each logic, it may divide it into worker classes.
 The logic functions as the glue between all workers and the display.
 The logic holds all data models necessary to work on in this scene and if needed it provides the data for routing purposes.
 All routings have to be executed via the logic, but be done by the router class which is hold by the logic.
 */
class ReminderLogic {
	// MARK: - Dependencies

	/// A weak reference to the display.
	private weak var display: ReminderDisplayInterface?

	/// The strong reference to the router.
	private let router: ReminderRouterInterface

	/// The data model holding the current scene state.
	var contentData = ReminderLogicModel.ContentData()

	/// The global data from the content data.
	private var globalData: GlobalData {
		guard let globalData = contentData.globalData else { fatalError() }
		return globalData
	}

	/// A closure which returns true when the device is currently in landscape otherwise false.
	/// Defaultly this returns `UIDevice.current.orientation.isLandscape`.
	var isDeviceOrientationLandscape: () -> Bool = {
		UIDevice.current.orientation.isLandscape
	}

	// MARK: - Init

	/**
	 Sets up the instance with references.

	 - parameter display: The reference to the display, hold weakly.
	 - parameter router: The reference to the router, hold strongly.
	 */
	init(display: ReminderDisplayInterface, router: ReminderRouterInterface) {
		self.display = display
		self.router = router
	}
}

// MARK: - ReminderLogicInterface

extension ReminderLogic: ReminderLogicInterface {
	// MARK: - Models

	func setModel(_ model: ReminderRouterModel.Setup) {
		contentData = ReminderLogicModel.ContentData()
		contentData.globalData = model.globalData
	}

	// MARK: - Requests

	func requestDisplayData() {
		let isLandscape = isDeviceOrientationLandscape()
		let displayModel = ReminderDisplayModel.UpdateDisplay(
			largeStyle: isLandscape,
			checkboxChecked: globalData.internalSettings.reminderOn,
			pickerValue: globalData.internalSettings.reminderTime
		)
		display?.updateDisplay(model: displayModel)
	}

	// MARK: - Actions

	func backButtonPressed() {
		router.routeBack()
	}

	func toggleCheckbox() {
		globalData.internalSettings.reminderOn = !globalData.internalSettings.reminderOn
		requestDisplayData()

		if !globalData.notificationWorker.authorizationRequested {
			// Ask for authorization to send local notifications.
			globalData.notificationWorker.requestAuthorization { [weak self] notificationWorker in
				guard notificationWorker.authorizationRequested else {
					// Error
					return
				}
				guard notificationWorker.isAuthorized else { return }

				// Setup local notifications.
				guard let globalData = self?.globalData else { return }
				notificationWorker.setupLocalNotifications(
					internalSettings: globalData.internalSettings,
					dataModelManager: globalData.dataModelManager
				)
			}
		} else {
			// Setup local notifications.
			globalData.notificationWorker.setupLocalNotifications(
				internalSettings: globalData.internalSettings,
				dataModelManager: globalData.dataModelManager
			)
		}
	}

	func timePickerChanged(newValue: Int) {
		precondition(newValue >= 0)
		globalData.internalSettings.reminderTime = newValue

		// Setup local notifications.
		globalData.notificationWorker.setupLocalNotifications(
			internalSettings: globalData.internalSettings,
			dataModelManager: globalData.dataModelManager
		)
	}
}
