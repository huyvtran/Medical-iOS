import AVFoundation

/**
 A text to speech synthesizer. Uses the `AVSpeechSynthesizer` from `AVFoundation`.
 */
class SpeechSynthesizer: NSObject {
	// MARK: - Properties

	/// The speech synthesizer used under the hood.
	private let synthesizer = AVSpeechSynthesizer()

	/// The delegate to inform about speaking states.
	private weak var delegate: SpeechSynthesizerDelegate?

	/// A BCP-47 code specifying the language and the locale using for the voice.
	private let voiceLanguage: String

	/// The speech data to read.
	private var speechData: [SpeechData]?

	/// The index pointing to the `speechData` which is currently reading out. Only valid if `currentlySpeaking` is `true`.
	private var speechIndex = 0

	/// Whether the speech synthesizer is currently running, speaking the data out or it is idle waiting to start.
	private var speechState = SpeechStateType.idle

	/// The different states of the speech.
	private enum SpeechStateType {
		/// No speech, waiting to start.
		case idle
		/// Speech in progress, data is beeing processed.
		case speaking
		/// Speech in progress, but cancelling to end with the next step.
		case cancelled
	}

	// MARK: - Init

	/**
	 Initializes the speech synthesizer.

	 - parameter delegate: The delegate to inform about speech changes.
	 - parameter voiceLanguage: The BCP-47 code specifying the language and the locale using for the voice. Defaults to german `de-DE`.
	 */
	init(delegate: SpeechSynthesizerDelegate, voiceLanguage: String = "de-DE") {
		self.delegate = delegate
		self.voiceLanguage = voiceLanguage
		super.init()

		synthesizer.delegate = self
	}

	deinit {
		synthesizer.stopSpeaking(at: .immediate)
	}

	// MARK: - Helper

	/**
	 Speaks out a given text via Apple's speech synthesizer.

	 - parameter text: The text to speak out.
	 */
	private func speak(text: String) {
		let speechUtterance = AVSpeechUtterance(string: text)
		speechUtterance.voice = AVSpeechSynthesisVoice(language: voiceLanguage)
		synthesizer.speak(speechUtterance)
	}
}

// MARK: - SpeechSynthesizerInterface

extension SpeechSynthesizer: SpeechSynthesizerInterface {
	func setSpeechData(data: [SpeechData]) {
		stopSpeaking()
		speechData = data
	}

	var isSpeaking: Bool { return [.speaking, .cancelled].contains(speechState) }

	func startSpeaking() {
		guard speechState == .idle else { return }
		guard let speechData = speechData else { return }
		guard speechData.count > 0 else { return }

		// Set new state and start speaking the first entry.
		speechState = .speaking
		speechIndex = 0
		speak(text: speechData[speechIndex].text)
	}

	func stopSpeaking() {
		guard speechState == .speaking else { return }

		// Set state to cancel and stop current speech.
		speechState = .cancelled
		if !synthesizer.stopSpeaking(at: .immediate) {
			speechState = .idle
		}
	}
}

// MARK: - AVSpeechSynthesizerDelegate

extension SpeechSynthesizer: AVSpeechSynthesizerDelegate {
	func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
		guard let speechData = speechData, let delegate = delegate else {
			speechState = .idle
			return
		}

		// Inform delegate about speech start.
		let data = speechData[speechIndex]
		delegate.speechStarted(for: data)
	}

	func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
		guard let speechData = speechData, let delegate = delegate else {
			speechState = .idle
			return
		}

		// Inform delegate about speech end.
		let data = speechData[speechIndex]
		delegate.speechEnded(for: data)

		// Continue with the next element in queue.
		speechIndex += 1
		if speechState == .cancelled {
			// Speech cancelled, just clean up.
			speechState = .idle
		} else if speechData.count > speechIndex {
			// Element exists, start speaking it out.
			speak(text: speechData[speechIndex].text)
		} else {
			// Index out of bounds, speech has finished.
			speechState = .idle
			delegate.speechFinished()
		}
	}

	func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
		// Inform delegate about speech end.
		if let speechData = speechData, let delegate = delegate {
			let data = speechData[speechIndex]
			delegate.speechEnded(for: data)
		}

		// Clean up state.
		speechState = .idle
	}
}
