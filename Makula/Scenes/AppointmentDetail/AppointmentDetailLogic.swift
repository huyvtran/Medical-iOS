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
class AppointmentDetailLogic {
	// MARK: - Dependencies

	/// A weak reference to the display.
	private weak var display: AppointmentDetailDisplayInterface?

	/// The strong reference to the router.
	private let router: AppointmentDetailRouterInterface

	/// The data model holding the current scene state.
	var contentData = AppointmentDetailLogicModel.ContentData()

	/// The global data from the content data.
	private var globalData: GlobalData {
		guard let globalData = contentData.globalData else { fatalError() }
		return globalData
	}

	/// The synthesizer for speech text.
	lazy var speechSynthesizer: SpeechSynthesizerInterface = {
		SpeechSynthesizer(delegate: self)
	}()

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
	init(display: AppointmentDetailDisplayInterface, router: AppointmentDetailRouterInterface) {
		self.display = display
		self.router = router
	}
}

// MARK: - AppointmentDetailLogicInterface

extension AppointmentDetailLogic: AppointmentDetailLogicInterface {
	// MARK: - Models

	func setModel(_ model: AppointmentDetailRouterModel.Setup) {
		contentData = AppointmentDetailLogicModel.ContentData()
		contentData.globalData = model.globalData
		contentData.date = model.date
	}

	func setSpeechData(data: [SpeechData]) {
		speechSynthesizer.setSpeechData(data: data)
	}

	// MARK: - Requests

	func requestDisplayData() {
		guard let date = contentData.date else { fatalError() }

		// Determine the title's color depending on the appointment.
		let appointments = globalData.dataModelManager.getAppointmentModels(forDay: date)
		var titleColor = Const.Color.white
		if let appointments = appointments, appointments.count == 1, let appointment = appointments.first {
			titleColor = appointment.type.defaultColor()
		}

		// Prepare display model.
		let isLandscape = isDeviceOrientationLandscape()
		let titleString = CommonDateFormatter.formattedStringWithWeekday(date: date)
		let displayModel = AppointmentDetailDisplayModel.UpdateDisplay(
			largeStyle: isLandscape,
			date: date,
			dataModelManager: globalData.dataModelManager,
			title: titleString,
			titleColor: titleColor
		)
		display?.updateDisplay(model: displayModel)
	}

	// MARK: - Actions

	func backButtonPressed() {
		// Stop speech.
		speechSynthesizer.stopSpeaking()

		// Perform route.
		router.routeBack()
	}

	func speakButtonPressed() {
		if speechSynthesizer.isSpeaking {
			speechSynthesizer.stopSpeaking()
		} else {
			speechSynthesizer.startSpeaking()
		}
	}

	func deletePressed() {
		display?.confirmDeletion()
	}

	func deleteConfirmed() {
		// Delete data.
		guard let date = contentData.date else { return }
		globalData.dataModelManager.deleteData(forDay: date)

		// Setup local notifications.
		globalData.notificationWorker.setupLocalNotifications(
			internalSettings: globalData.internalSettings,
			dataModelManager: globalData.dataModelManager
		)

		// Update display.
		requestDisplayData()
	}

	func routeToNotes() {
		// Stop speech.
		speechSynthesizer.stopSpeaking()

		// Perform route.
		let date = contentData.date ?? Date()
		let model = NoteRouterModel.Setup(globalData: globalData, date: date)
		router.routeToNote(model: model)
	}
}

// MARK: - SpeechSynthesizerDelegate

extension AppointmentDetailLogic: SpeechSynthesizerDelegate {
	func speechStarted(for speechData: SpeechData) {
		display?.setHighlightCell(for: speechData, highlight: true)
	}

	func speechEnded(for speechData: SpeechData) {
		display?.setHighlightCell(for: speechData, highlight: false)
	}

	func speechFinished() {
		display?.scrollToTop()
	}
}
