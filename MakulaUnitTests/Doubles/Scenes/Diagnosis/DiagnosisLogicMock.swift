@testable import Makula
import XCTest

/// A testing mock for when something depends on `DiagnosisLogicInterface`.
class DiagnosisLogicMock: BaseMock, DiagnosisLogicInterface {
	// MARK: -

	var setModelStub: (_ model: DiagnosisRouterModel.Setup) -> Void = { _ in BaseMock.fail() }

	func setModel(_ model: DiagnosisRouterModel.Setup) {
		setModelStub(model)
	}

	// MARK: -

	var setSpeechDataStub: (_ data: [SpeechData]) -> Void = { _ in BaseMock.fail() }

	func setSpeechData(data: [SpeechData]) {
		setSpeechDataStub(data)
	}

	// MARK: -

	var requestDisplayDataStub: () -> Void = { BaseMock.fail() }

	func requestDisplayData() {
		requestDisplayDataStub()
	}

	// MARK: -

	var databaseWriteErrorStub: () -> Void = { BaseMock.fail() }

	func databaseWriteError() {
		databaseWriteErrorStub()
	}

	// MARK: -

	var backButtonPressedStub: () -> Void = { BaseMock.fail() }

	func backButtonPressed() {
		backButtonPressedStub()
	}

	// MARK: -

	var speakButtonPressedStub: () -> Void = { BaseMock.fail() }

	func speakButtonPressed() {
		speakButtonPressedStub()
	}

	// MARK: -

	var infoButtonPressedStub: (_ type: InfoType) -> Void = { _ in BaseMock.fail() }

	func infoButtonPressed(type: InfoType) {
		infoButtonPressedStub(type)
	}
}
