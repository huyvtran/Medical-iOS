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
class InfoLogic {
	// MARK: - Dependencies

	/// A weak reference to the display.
	private weak var display: InfoDisplayInterface?

	/// The strong reference to the router.
	private let router: InfoRouterInterface

	/// The data model holding the current scene state.
	var contentData = InfoLogicModel.ContentData()

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

	/// The mail controller for the MessageUI.
	var mailController = MailController()

	// MARK: - Init

	/**
	 Sets up the instance with references.

	 - parameter display: The reference to the display, hold weakly.
	 - parameter router: The reference to the router, hold strongly.
	 */
	init(display: InfoDisplayInterface, router: InfoRouterInterface) {
		self.display = display
		self.router = router
	}
}

// MARK: - InfoLogicInterface

extension InfoLogic: InfoLogicInterface {
	// MARK: - Models

	func setModel(_ model: InfoRouterModel.Setup) {
		contentData = InfoLogicModel.ContentData()
		contentData.globalData = model.globalData
		contentData.sceneType = model.sceneType

		// Set speech data.
		let speechData = SpeechData(text: model.sceneType.speechText(), indexPath: nil)
		speechSynthesizer.setSpeechData(data: [speechData])
	}

	// MARK: - Requests

	func requestDisplayData() {
		let isLandscape = isDeviceOrientationLandscape()
		let type = contentData.sceneType ?? .amd
		let displayModel = InfoDisplayModel.UpdateDisplay(largeStyle: isLandscape, sceneType: type)
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

	func bottomButtonPressed() {
		guard let sceneType = contentData.sceneType else { fatalError() }

		switch sceneType {
		case .backup:
			startBackup()
		default:
			fatalError()
		}
	}

	private func startBackup() {
		// Update state.
		guard !contentData.processing else { return }
		contentData.processing = true
		display?.setBottomButtonVisible(false)

		// Export data.
		globalData.dataModelManager.exportData { [weak self] data in
			guard let strongSelf = self else { return }

			defer {
				// Reset state.
				strongSelf.contentData.processing = false
				strongSelf.display?.setBottomButtonVisible(true)
			}

			guard let data = data else {
				strongSelf.display?.showError(title: R.string.info.backupErrorTitle(), message: R.string.info.backupErrorMessage())
				return
			}

			// Attach data to email and present to user.
			let dateString = CommonDateFormatter.formattedString(date: Date())
			let fileName = R.string.info.backupFileName(dateString)
			guard let mail = strongSelf.mailController.createMail(attachment: data, mimeType: Const.Backup.fileMimeType, fileName: fileName) else {
				// Emails can't be send, inform user.
				strongSelf.display?.showError(title: R.string.contactDetails.emailFailureTitle(), message: R.string.contactDetails.emailFailureMessage())
				return
			}
			strongSelf.display?.presentMail(controller: mail)
		}
	}
}

// MARK: - SpeechSynthesizerDelegate

extension InfoLogic: SpeechSynthesizerDelegate {
	func speechStarted(for speechData: SpeechData) {}

	func speechEnded(for speechData: SpeechData) {}

	func speechFinished() {}
}
