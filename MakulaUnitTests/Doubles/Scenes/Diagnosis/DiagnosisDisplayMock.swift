@testable import Makula
import XCTest

/// A testing mock for when something depends on `DiagnosisDisplayInterface`.
class DiagnosisDisplayMock: BaseMock, DiagnosisDisplayInterface {
	// MARK: -

	var updateDisplayStub: (_ model: DiagnosisDisplayModel.UpdateDisplay) -> Void = { _ in BaseMock.fail() }

	func updateDisplay(model: DiagnosisDisplayModel.UpdateDisplay) {
		updateDisplayStub(model)
	}

	// MARK: -

	var showDatabaseWriteErrorStub: () -> Void = { BaseMock.fail() }

	func showDatabaseWriteError() {
		showDatabaseWriteErrorStub()
	}

	// MARK: -

	var scrollToTopStub: () -> Void = { BaseMock.fail() }

	func scrollToTop() {
		scrollToTopStub()
	}

	// MARK: -

	var setHighlightCellStub: (_ speechData: SpeechData, _ highlight: Bool) -> Void = { _, _ in BaseMock.fail() }

	func setHighlightCell(for speechData: SpeechData, highlight: Bool) {
		setHighlightCellStub(speechData, highlight)
	}
}
