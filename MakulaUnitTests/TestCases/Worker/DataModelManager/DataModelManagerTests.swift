@testable import Makula
import RealmSwift
import XCTest

class DataModelManagerTests: TestCase {
	// MARK: - Setup

	/// The manager object under test.
	var sut: DataModelManager!

	override func setUp() {
		super.setUp()

		sut = DataModelManager()
		sut.deleteDatabase()
	}

	override func tearDown() {
		sut = nil
		super.tearDown()
	}

	// MARK: - Tests

	// MARK: defaultConfiguration

	/// The default configuration has valid data.
	func testDefaultConfiguration() {
		// Get configuration.
		let configuration = sut.defaultConfiguration

		// Valid path.
		guard let url = configuration.fileURL else { XCTFail(); return }
		XCTAssertEqual("default.realm", url.lastPathComponent)
		XCTAssertEqual("Database", url.deletingLastPathComponent().lastPathComponent)
		// Latest version.
		XCTAssertEqual(Const.DataModelManager.latestVersionNumber, configuration.schemaVersion)
		// No migration block.
		XCTAssertNil(configuration.migrationBlock)
		// No encryption.
		XCTAssertNil(configuration.encryptionKey)
		// Not in memory.
		XCTAssertNil(configuration.inMemoryIdentifier)
	}

	// MARK: touchDatabase

	/// No update when touching the database.
	func testTouchDatabaseNoUpdate() {
		// Initialize database.
		let initExpectation = expectation(description: "initExpectation")
		sut.touchDatabase(testScenario: nil, handler: { state in
			if .finished == state {
				initExpectation.fulfill()
			}
		})

		// Wait for initialization.
		waitForExpectations(timeout: 5.0)

		// Method under test.
		let stateExpectation = expectation(description: "stateExpectation")
		sut.touchDatabase(testScenario: nil, handler: { state in
			if state == .finished {
				stateExpectation.fulfill()
			} else {
				XCTFail()
			}
		})

		// Wait for all expectations.
		waitForExpectations(timeout: 5.0)
	}

	/// Touching the database failed.
	func testTouchDatabaseFail() {
		// Set up test configuration.
		sut.defaultConfiguration.readOnly = true

		// Method under test.
		let stateExpectation = expectation(description: "stateExpectation")
		sut.touchDatabase(testScenario: nil, handler: { state in
			XCTAssertEqual(.initError, state)
			stateExpectation.fulfill()
		})

		// Wait for all expectations.
		waitForExpectations(timeout: 5.0)
	}

	/// Touching the database on a fresh install migrates to the latest version.
	func testTouchDatabaseInit() {
		// Method under test.
		var lastState: DataModelTouchState?
		let lastStateExpectation = expectation(description: "lastStateExpectation")
		sut.touchDatabase(testScenario: nil, handler: { state in
			// Expect the states go throught the correct order.
			if lastState == nil {
				XCTAssertEqual(.beginMigration, state)
				lastState = state
			} else if lastState == .beginMigration {
				XCTAssertEqual(.finished, state)
				lastStateExpectation.fulfill()
			} else {
				XCTFail()
			}
		})

		// Wait for all expectations.
		waitForExpectations(timeout: 5.0)
	}

	/// The required database content for v1 is present.
	func testDatabaseContentV1() {
		// Expect the database gets initialized.
		let stateExpectation = expectation(description: "stateExpectation")
		sut.touchDatabase(testScenario: nil, handler: { state in
			if state == .finished {
				stateExpectation.fulfill()
			}
		})

		// Wait for all expectations.
		waitForExpectations(timeout: 10.0)

		autoreleasepool {
			do {
				let realm = try Realm(configuration: sut.defaultConfiguration)

				// Assert default Diagnosis entries.
				let diagnosisModels = realm.objects(DiagnosisModel.self).sorted(byKeyPath: "sortOrderPosition")
				guard diagnosisModels.count == 4 else { XCTFail(); return }
				XCTAssertEqual(diagnosisModels[0].type, DiagnosisType.amd)
				XCTAssertEqual(diagnosisModels[1].type, DiagnosisType.dmo)
				XCTAssertEqual(diagnosisModels[2].type, DiagnosisType.rvv)
				XCTAssertEqual(diagnosisModels[3].type, DiagnosisType.mcnv)
			} catch let error {
				XCTFail("Error: \(error)")
			}
		}
	}

	// MARK: write

	/// The write operation succeeded.
	func testWriteSuccess() {
		// Set up test configuration.
		sut.defaultConfiguration.inMemoryIdentifier = #function

		// Prepare model to write.
		let model = DiagnosisModel()

		// Method under test.
		let result = sut.write { realm in
			realm.add(model)
		}

		// Assert result.
		XCTAssertTrue(result)
	}

	/// The write operation failed.
	func testWriteFail() {
		// Set up test configuration.
		sut.defaultConfiguration.inMemoryIdentifier = #function
		sut.defaultConfiguration.readOnly = true

		// Prepare model to write.
		let model = DiagnosisModel()

		// Method under test.
		let result = sut.write { realm in
			realm.add(model)
		}

		// Assert result.
		XCTAssertFalse(result)
	}
}
