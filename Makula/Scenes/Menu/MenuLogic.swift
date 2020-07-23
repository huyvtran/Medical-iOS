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
class MenuLogic {
	// MARK: - Dependencies

	/// A weak reference to the display.
	private weak var display: MenuDisplayInterface?

	/// The strong reference to the router.
	private let router: MenuRouterInterface

	/// The data model holding the current scene state.
	var contentData = MenuLogicModel.ContentData()

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

	/// The menu and all sub-menu scenes allowed to pass to as routing to a menu.
	private let submenuScenes: [SceneId] = [
		.home, .doctorVisit, .selfTest, .knowledge,
		.settings, .illness, .examination, .therapy,
		.activities, .aid, .support
	]

	// MARK: - Init

	/**
	 Sets up the instance with references.

	 - parameter display: The reference to the display, hold weakly.
	 - parameter router: The reference to the router, hold strongly.
	 */
	init(display: MenuDisplayInterface, router: MenuRouterInterface) {
		self.display = display
		self.router = router
	}
}

// MARK: - MenuLogicInterface

extension MenuLogic: MenuLogicInterface {
	// MARK: - Models

	func setModel(_ model: MenuRouterModel.Setup) {
		contentData = MenuLogicModel.ContentData()
		contentData.globalData = model.globalData
		precondition(submenuScenes.contains(model.sceneId))
		contentData.sceneId = model.sceneId
	}

	func setSpeechData(data: [SpeechData]) {
		speechSynthesizer.setSpeechData(data: data)
	}

	// MARK: - Requests

	func requestDisplayData() {
		speechSynthesizer.stopSpeaking()

		let isLandscape = isDeviceOrientationLandscape()
		let isRoot = contentData.sceneId == .home
		let sceneId = contentData.sceneId ?? .other
		let dataModelManager = globalData.dataModelManager
		let displayModel = MenuDisplayModel.UpdateDisplay(
			isRoot: isRoot,
			largeStyle: isLandscape,
			sceneId: sceneId,
			dataModelManager: dataModelManager
		)
		display?.updateDisplay(model: displayModel)
	}

	// MARK: - Actions

	func backButtonPressed() {
		// Stop speech.
		speechSynthesizer.stopSpeaking()

		// Perform route.
		router.routeBackToMenu()
	}

	func speakButtonPressed() {
		if speechSynthesizer.isSpeaking {
			speechSynthesizer.stopSpeaking()
		} else {
			speechSynthesizer.startSpeaking()
		}
	}

	// MARK: - Routings

	func routeToMenu(sceneId: SceneId) {
		precondition(submenuScenes.contains(sceneId))

		// Stop speech.
		speechSynthesizer.stopSpeaking()

		// Perform route.
		let model = MenuRouterModel.Setup(globalData: globalData, sceneId: sceneId)
		router.routeToMenu(model: model)
	}

	func routeToNewAppointment() {
		// Stop speech.
		speechSynthesizer.stopSpeaking()

		// Perform route.
		let model = NewAppointmentRouterModel.Setup(globalData: globalData)
		router.routeToNewAppointment(model: model)
	}

	func routeToContact() {
		// Stop speech.
		speechSynthesizer.stopSpeaking()

		// Perform route.
		let model = ContactRouterModel.Setup(globalData: globalData)
		router.routeToContact(model: model)
	}

	func routeToMedicament() {
		// Stop speech.
		speechSynthesizer.stopSpeaking()

		// Perform route.
		let model = MedicamentRouterModel.Setup(globalData: globalData)
		router.routeToMedicament(model: model)
	}

	func routeToDiagnosis() {
		// Stop speech.
		speechSynthesizer.stopSpeaking()

		// Perform route.
		let model = DiagnosisRouterModel.Setup(globalData: globalData)
		router.routeToDiagnosis(model: model)
	}

	func routeToVisusNhdInput(type: VisusNhdType) {
		// Stop speech.
		speechSynthesizer.stopSpeaking()

		// Perform route.
		let model = VisusNhdInputRouterModel.Setup(globalData: globalData, sceneType: type)
		router.routeToVisusNhdInput(model: model)
	}

	func routeToCalendar() {
		// Stop speech.
		speechSynthesizer.stopSpeaking()

		// Perform route.
		let model = CalendarRouterModel.Setup(
			globalData: globalData,
			modifyNavigationStack: false,
			focusDate: nil
		)
		router.routeToCalendar(model: model)
	}

	func routeToAmslertest() {
		// Stop speech.
		speechSynthesizer.stopSpeaking()

		// Perform route.
		let model = AmslertestRouterModel.Setup(globalData: globalData)
		router.routeToAmslertest(model: model)
	}

	func routeToReadingTest() {
		// Stop speech.
		speechSynthesizer.stopSpeaking()

		// Perform route.
		let model = ReadingTestRouterModel.Setup(globalData: globalData)
		router.routeToReadingTest(model: model)
	}

	func routeToGraph() {
		// Stop speech.
		speechSynthesizer.stopSpeaking()

		// Perform route.
		let model = GraphRouterModel.Setup(
			globalData: globalData,
			modifyNavigationStack: false,
			eyeType: .left
		)
		router.routeToGraph(model: model)
	}

	func routeToAppointmentDetail(date: Date) {
		// Stop speech.
		speechSynthesizer.stopSpeaking()

		// Perform route.
		let routerModel = AppointmentDetailRouterModel.Setup(globalData: globalData, date: date)
		router.routeToAppointmentDetail(model: routerModel)
	}

	func routeToInfo(infoType: InfoType) {
		// Stop speech.
		speechSynthesizer.stopSpeaking()

		// Perform route.
		let model = InfoRouterModel.Setup(globalData: globalData, sceneType: infoType)
		router.routeToInformation(model: model)
	}

	func routeToSearch() {
		// Stop speech.
		speechSynthesizer.stopSpeaking()

		// Perform route.
		let model = SearchRouterModel.Setup(globalData: globalData)
		router.routeToSearch(model: model)
	}

	func routeToReminder() {
		// Stop speech.
		speechSynthesizer.stopSpeaking()

		// Perform route.
		let model = ReminderRouterModel.Setup(globalData: globalData)
		router.routeToReminder(model: model)
	}
}

// MARK: - SpeechSynthesizerDelegate

extension MenuLogic: SpeechSynthesizerDelegate {
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
