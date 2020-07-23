@testable import Makula
import XCTest

/// A testing mock for when something depends on `NewAppointmentDisplayInterface`.
class NewAppointmentDisplayMock: BaseMock, NewAppointmentDisplayInterface {
	// MARK: -

	var updateDisplayStub: (_ model: NewAppointmentDisplayModel.UpdateDisplay) -> Void = { _ in BaseMock.fail() }

	func updateDisplay(model: NewAppointmentDisplayModel.UpdateDisplay) {
		updateDisplayStub(model)
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
