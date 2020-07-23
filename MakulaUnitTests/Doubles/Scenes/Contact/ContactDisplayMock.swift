@testable import Makula
import XCTest

/// A testing mock for when something depends on `ContactDisplayInterface`.
class ContactDisplayMock: BaseMock, ContactDisplayInterface {
	// MARK: -

	var updateDisplayStub: (_ model: ContactDisplayModel.UpdateDisplay) -> Void = { _ in BaseMock.fail() }

	func updateDisplay(model: ContactDisplayModel.UpdateDisplay) {
		updateDisplayStub(model)
	}

	// MARK: -

	var showDatabaseWriteErrorStub: () -> Void = { BaseMock.fail() }

	func showDatabaseWriteError() {
		showDatabaseWriteErrorStub()
	}
}
