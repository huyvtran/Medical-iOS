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
class ContactDetailsLogic {
	// MARK: - Dependencies

	/// A weak reference to the display.
	private weak var display: ContactDetailsDisplayInterface?

	/// The strong reference to the router.
	private let router: ContactDetailsRouterInterface

	/// The data model holding the current scene state.
	var contentData = ContactDetailsLogicModel.ContentData()

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
	init(display: ContactDetailsDisplayInterface, router: ContactDetailsRouterInterface) {
		self.display = display
		self.router = router
	}
}

// MARK: - ContactDetailsLogicInterface

extension ContactDetailsLogic: ContactDetailsLogicInterface {
	// MARK: - Models

	func setModel(_ model: ContactDetailsRouterModel.Setup) {
		contentData = ContactDetailsLogicModel.ContentData()
		contentData.globalData = model.globalData
		contentData.contactModel = model.contactModel
	}

	func setSpeechData(data: [SpeechData]) {
		speechSynthesizer.setSpeechData(data: data)
	}

	// MARK: - Requests

	func requestDisplayData() {
		let isLandscape = isDeviceOrientationLandscape()
		guard let contactModel = contentData.contactModel else { fatalError() }
		let displayModel = ContactDetailsDisplayModel.UpdateDisplay(
			largeStyle: isLandscape,
			dataModelManager: globalData.dataModelManager,
			contactModel: contactModel
		)
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

	// MARK: - Custom actions

	func sendSms(mobileNumber: String) {
		let urlString = "sms://" + mobileNumber
		guard let url = URL(string: urlString) else {
			display?.showError(title: R.string.contactDetails.smsFailureTitle(), message: R.string.contactDetails.smsFailureMessage())
			return
		}
		UIApplication.shared.open(url)
	}

	func startPhoneCall(phoneNumber: String) {
		display?.askForPhoneCall(phoneNumber: phoneNumber)
	}

	func initiatePhoneCall(phoneNumber: String) {
		guard let url = URL(string: "tel://" + phoneNumber) else {
			display?.showError(title: R.string.contactDetails.phoneFailureTitle(), message: R.string.contactDetails.phoneFailureMessage())
			return
		}
		UIApplication.shared.open(url)
	}

	func sendEmail(emailAddress: String) {
		display?.showMail(emailAddress: emailAddress)
	}

	func openWeb(webAddress: String) {
		var urlString = webAddress
		if !urlString.hasPrefix("http") { // URL should start with http or https
			urlString = "http://" + urlString
		}
		guard let url = URL(string: urlString) else {
			display?.showError(title: R.string.contactDetails.webFailureTitle(), message: R.string.contactDetails.webFailureMessage())
			return
		}
		UIApplication.shared.open(url)
	}
}

// MARK: - SpeechSynthesizerDelegate

extension ContactDetailsLogic: SpeechSynthesizerDelegate {
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
