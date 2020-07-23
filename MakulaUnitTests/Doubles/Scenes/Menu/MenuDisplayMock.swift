@testable import Makula
import XCTest

/// A testing mock for when something depends on `MenuDisplayInterface`.
class MenuDisplayMock: BaseMock, MenuDisplayInterface {
	// MARK: -

	var updateDisplayStub: (_ model: MenuDisplayModel.UpdateDisplay) -> Void = { _ in BaseMock.fail() }

	func updateDisplay(model: MenuDisplayModel.UpdateDisplay) {
		updateDisplayStub(model)
	}

	var scrollToTopStub: () -> Void = { BaseMock.fail() }

	func scrollToTop() {
		scrollToTopStub()
	}

	var setHighlightCellStub: (_ speechData: SpeechData, _ highlight: Bool) -> Void = { _, _ in BaseMock.fail() }

	func setHighlightCell(for speechData: SpeechData, highlight: Bool) {
		setHighlightCellStub(speechData, highlight)
	}
}
