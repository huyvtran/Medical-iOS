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
class MedicamentLogic {
	// MARK: - Dependencies

	/// A weak reference to the display.
	private weak var display: MedicamentDisplayInterface?

	/// The strong reference to the router.
	private let router: MedicamentRouterInterface

	/// The data model holding the current scene state.
	var contentData = MedicamentLogicModel.ContentData()

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
	init(display: MedicamentDisplayInterface, router: MedicamentRouterInterface) {
		self.display = display
		self.router = router
	}
}

// MARK: - MedicamentLogicInterface

extension MedicamentLogic: MedicamentLogicInterface {
	// MARK: - Models

	func setModel(_ model: MedicamentRouterModel.Setup) {
		contentData = MedicamentLogicModel.ContentData()
		contentData.globalData = model.globalData
	}

	func setSpeechData(data: [SpeechData]) {
		speechSynthesizer.setSpeechData(data: data)
	}

	// MARK: - Requests

	func requestDisplayData() {
		let isLandscape = isDeviceOrientationLandscape()
		let displayModel = MedicamentDisplayModel.UpdateDisplay(largeStyle: isLandscape, dataModelManager: globalData.dataModelManager)
		display?.updateDisplay(model: displayModel)
	}

	func databaseWriteError() {
		display?.showDatabaseWriteError()
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
}

// MARK: - SpeechSynthesizerDelegate

extension MedicamentLogic: SpeechSynthesizerDelegate {
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
