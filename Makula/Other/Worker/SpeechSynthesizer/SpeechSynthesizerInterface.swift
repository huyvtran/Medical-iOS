import AVFoundation

/**
 A text to speech synthesizer.
 */
protocol SpeechSynthesizerInterface: class {
	/**
	 Sets the speech data so the synthesizer can loop through it for speaking out.
	 Stops speaking if currently in progress.

	 - parameter data: The current speech data to use when speaking out.
	 */
	func setSpeechData(data: [SpeechData])

	/// Flag whether the synthesizer is currently in speech mode reading out the text data or not.
	var isSpeaking: Bool { get }

	/**
	 Starts the speech mode of the synthesizer.
	 Does nothing if no speech data is provided or speaking is currently already in progress.

	 This starts reading out the previously provided speech data from the beginning looping through the array.
	 Before calling this the speech data has to be provided via `setSpeechData(data:)`.
	 */
	func startSpeaking()

	/**
	 Stops the speech immediately, does nothing if speaking has not been started or has already finished.
	 */
	func stopSpeaking()
}
