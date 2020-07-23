@testable import Makula
import XCTest

/// A testing mock for when something depends on `ContactLogicInterface`.
class ContactLogicMock: BaseMock, ContactLogicInterface {
	// MARK: -

	var setModelStub: (_ model: ContactRouterModel.Setup) -> Void = { _ in BaseMock.fail() }

	func setModel(_ model: ContactRouterModel.Setup) {
		setModelStub(model)
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

	var addButtonPressedStub: () -> Void = { BaseMock.fail() }

	func addButtonPressed() {
		addButtonPressedStub()
	}

	// MARK: -

	var contactSelectedStub: (_ contact: ContactModel) -> Void = { _ in BaseMock.fail() }

	func contactSelected(_ contact: ContactModel) {
		contactSelectedStub(contact)
	}
}
