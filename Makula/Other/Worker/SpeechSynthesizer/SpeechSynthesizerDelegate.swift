import Foundation

/// The delegate of a `SpeechSynthesizer` which gets informed about speaking states.
protocol SpeechSynthesizerDelegate: class {
	/**
	 The speaking for a specific element has started.

	 - parameter speechData: The speech data which just has been started to speak out.
	 */
	func speechStarted(for speechData: SpeechData)

	/**
	 The speaking for a specific element has ended.
	 Is also called when the speech has been stopped manually.

	 - parameter speechData: The speech data which just has been ended to speak out.
	 */
	func speechEnded(for speechData: SpeechData)

	/**
	 The speech mode has ended, the last element in queue have been spoken out.
	 Is not called when the speech has been stopped manually.
	 */
	func speechFinished()
}
