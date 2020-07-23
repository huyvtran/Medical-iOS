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
class NoteLogic {
	// MARK: - Dependencies

	/// A weak reference to the display.
	private weak var display: NoteDisplayInterface?

	/// The strong reference to the router.
	private let router: NoteRouterInterface

	/// The data model holding the current scene state.
	var contentData = NoteLogicModel.ContentData()

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
	init(display: NoteDisplayInterface, router: NoteRouterInterface) {
		self.display = display
		self.router = router
	}
}

// MARK: - NoteLogicInterface

extension NoteLogic: NoteLogicInterface {
	// MARK: - Models

	func setModel(_ model: NoteRouterModel.Setup) {
		contentData = NoteLogicModel.ContentData()
		contentData.globalData = model.globalData
		contentData.date = model.date
	}

	func setSpeechData(data: [SpeechData]) {
		speechSynthesizer.setSpeechData(data: data)
	}

	// MARK: - Requests

	func requestDisplayData() {
		// Get model.
		if contentData.noteModel == nil {
			guard let date = contentData.date else { fatalError() }
			guard let modelResults = globalData.dataModelManager.getNoteModel(forDay: date) else {
				fatalError()
			}

			if let model = modelResults.first {
				// Found an existing model for the day.
				contentData.noteModel = model
			} else {
				// No model for the day, create one temporarily.
				if let model = globalData.dataModelManager.createNoteModel(date: date) {
					contentData.noteModel = model
				} else {
					databaseWriteError()
				}
			}
		}

		// Update display.
		let largeStyle = isDeviceOrientationLandscape()
		let date = contentData.date ?? Date()
		let displayModel = NoteDisplayModel.UpdateDisplay(
			largeStyle: largeStyle,
			date: date,
			noteModel: contentData.noteModel,
			dataModelManager: globalData.dataModelManager
		)
		display?.updateDisplay(model: displayModel)
	}

	func databaseWriteError() {
		display?.showDatabaseWriteError()
	}

	func updateNoteModel(content: String?) {
		guard let model = contentData.noteModel else { fatalError() }

		// Updates the note model.
		if !globalData.dataModelManager.updateNoteModel(model, content: content) {
			databaseWriteError()
		} else {
			// Update the speech data if the model is successfully updated.
			let speechText = model.content ?? String.empty
			let speechData = SpeechData(text: speechText, indexPath: nil)
			setSpeechData(data: [speechData])
		}
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

extension NoteLogic: SpeechSynthesizerDelegate {
	func speechStarted(for speechData: SpeechData) {}

	func speechEnded(for speechData: SpeechData) {}

	func speechFinished() {}
}
