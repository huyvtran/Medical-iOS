@testable import Makula
import RealmSwift
import XCTest

/// A testing mock for when something depends on `DataModelManagerInterface`.
class DataModelManagerMock: BaseMock, DataModelManagerInterface {
	// MARK: -

	var defaultConfigurationGetStub: () -> Realm.Configuration = { BaseMock.fail(); return Realm.Configuration.defaultConfiguration }

	var defaultConfiguration: Realm.Configuration {
		return defaultConfigurationGetStub()
	}

	// MARK: -

	var touchDatabaseStub: (_ testScenario: Const.TestArgument.Scenario?, _ handler: @escaping (DataModelTouchState) -> Void) -> Void = { _, _ in
		BaseMock.fail()
	}

	func touchDatabase(testScenario: Const.TestArgument.Scenario?, handler: @escaping (DataModelTouchState) -> Void) {
		touchDatabaseStub(testScenario, handler)
	}

	// MARK: -

	var writeStub: (_ operations: (_ realm: Realm) throws -> Void) -> Bool = { _ in BaseMock.fail(); return false }

	func write(operations: (_ realm: Realm) throws -> Void) -> Bool {
		return writeStub(operations)
	}

	// MARK: -

	var backgroundWriteStub: (_ operations: (_ realm: Realm) throws -> Void) -> Void = { _ in BaseMock.fail() }

	func backgroundWrite(operations: @escaping (Realm) throws -> Void) {
		backgroundWriteStub(operations)
	}

	// MARK: -

	var exportDataStub: (_ completionHandler: @escaping (_ data: Data?) -> Void) -> Void = { _ in BaseMock.fail() }

	func exportData(completionHandler: @escaping (_ data: Data?) -> Void) {
		exportDataStub(completionHandler)
	}

	// MARK: -

	var importDataStub: (_ url: URL) -> Bool = { _ in BaseMock.fail(); return false }

	func importData(atUrl url: URL) -> Bool {
		return importDataStub(url)
	}
}
