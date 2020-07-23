import RealmSwift
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
class AppointmentDatePickerLogic {
	// MARK: - Dependencies

	/// A weak reference to the display.
	private weak var display: AppointmentDatePickerDisplayInterface?

	/// The strong reference to the router.
	private let router: AppointmentDatePickerRouterInterface

	/// The data model holding the current scene state.
	var contentData = AppointmentDatePickerLogicModel.ContentData()

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
	init(display: AppointmentDatePickerDisplayInterface, router: AppointmentDatePickerRouterInterface) {
		self.display = display
		self.router = router
	}
}

// MARK: - AppointmentDatePickerLogicInterface

extension AppointmentDatePickerLogic: AppointmentDatePickerLogicInterface {
	// MARK: - Models

	func setModel(_ model: AppointmentDatePickerRouterModel.Setup) {
		contentData = AppointmentDatePickerLogicModel.ContentData()
		contentData.globalData = model.globalData
		contentData.appointmentType = model.appointmentType
	}

	// MARK: - Requests

	func requestDisplayData() {
		let isLandscape = isDeviceOrientationLandscape()
		let displayModel = AppointmentDatePickerDisplayModel.UpdateDisplay(
			largeStyle: isLandscape
		)
		display?.updateDisplay(model: displayModel)

		// Get the date from an existing appointment or use the today's.
		guard let appointmentType = contentData.appointmentType else { return }
		let dataModelManager = globalData.dataModelManager
		var appointmentDate = Date()
		guard let appointmentsForDate = dataModelManager.getAppointmentModels(forDay: appointmentDate, type: appointmentType) else {
			databaseWriteError()
			return
		}
		if let existingAppointment = appointmentsForDate.first {
			appointmentDate = existingAppointment.date
		}

		// Inform the display to show the correct date for the picker.
		display?.updatePickerDate(model: AppointmentDatePickerDisplayModel.PickerDate(date: appointmentDate))
	}

	func databaseWriteError() {
		display?.showDatabaseWriteError()
	}

	// MARK: - Actions

	func backButtonPressed() {
		router.routeBackToNewAppointment()
	}

	func saveButtonPressed(withDate date: Date) {
		guard let appointmentType = contentData.appointmentType else { return }
		let dataModelManager = globalData.dataModelManager

		// Get any existing appointments for the date.
		guard let appointmentsForDate = dataModelManager.getAppointmentModels(forDay: date, type: appointmentType) else {
			databaseWriteError()
			return
		}

		// Persist appointment.
		if let existingAppointment = appointmentsForDate.first {
			// Found same type on the day, update it.
			if !dataModelManager.setAppointmentModel(existingAppointment, date: date) {
				databaseWriteError()
				return
			}
		} else {
			// Create new entry when none has been updated.
			dataModelManager.createAppointmentModel(type: appointmentType, date: date)
		}

		// Setup local notifications.
		globalData.notificationWorker.setupLocalNotifications(
			internalSettings: globalData.internalSettings,
			dataModelManager: globalData.dataModelManager
		)

		// Route to the calendar.
		let routerModel = CalendarRouterModel.Setup(
			globalData: globalData,
			modifyNavigationStack: true,
			focusDate: date
		)
		router.routeToCalendar(model: routerModel)
	}
}
