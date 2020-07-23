@testable import Makula
import XCTest

/// A testing mock for when something depends on `SpeechSynthesizerInterface`.
class SpeechSynthesizerMock: BaseMock, SpeechSynthesizerInterface {
	// MARK: -

	var setSpeechDataStub: (_ data: [SpeechData]) -> Void = { _ in BaseMock.fail() }

	func setSpeechData(data: [SpeechData]) {
		setSpeechDataStub(data)
	}

	// MARK: -

	var startSpeakingStub: () -> Void = { BaseMock.fail() }

	func startSpeaking() {
		startSpeakingStub()
	}

	// MARK: -

	var isSpeakingGetStub: () -> Bool = { BaseMock.fail(); return false }

	var isSpeaking: Bool {
		return isSpeakingGetStub()
	}

	// MARK: -

	var stopSpeakingStub: () -> Void = { BaseMock.fail() }

	func stopSpeaking() {
		stopSpeakingStub()
	}
}
