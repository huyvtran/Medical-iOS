import Foundation
import XCTest

/// A testing mock for when something depends on `UserDefaults`.
class UserDefaultsMock: UserDefaults {
	// MARK: - Mock

	private static var file: StaticString = ""
	private static var line: UInt = 0

	/**
	 Instantiates the mock and saves the code file and line where this happens.

	 - parameter file: The file, don't provide anything.
	 - parameter line: The line number, don't provide anything.
	 */
	convenience init(file: StaticString = #file, line: UInt = #line) {
		UserDefaultsMock.file = file
		UserDefaultsMock.line = line
		self.init()
	}

	/**
	 Fails the current running test and points to the locations where this has been called and where the mock has been instantiated.

	 Should only be called in closures where the function's name is equal to the class.

	 - parameter file: The file, don't provide anything.
	 - parameter line: The line number, don't provide anything.
	 */
	static func fail(file: StaticString = #file, line: UInt = #line) {
		// Fail in the line where this method is beeing called.
		XCTFail(file: file, line: line)
		// Fail also at the location where the mock has been instantiated.
		XCTFail(file: UserDefaultsMock.file, line: UserDefaultsMock.line)
	}

	// MARK: - Getting Default Values

	var objectForKeyStub: (_ defaultName: String) -> Any? = { _ in UserDefaultsMock.fail(); return nil }

	override func object(forKey defaultName: String) -> Any? {
		return objectForKeyStub(defaultName)
	}

	var urlForKeyStub: (_ defaultName: String) -> URL? = { _ in UserDefaultsMock.fail(); return nil }

	override func url(forKey defaultName: String) -> URL? {
		return urlForKeyStub(defaultName)
	}

	var arrayForKeyStub: (_ defaultName: String) -> [Any]? = { _ in UserDefaultsMock.fail(); return nil }

	override func array(forKey defaultName: String) -> [Any]? {
		return arrayForKeyStub(defaultName)
	}

	var dictionaryForKeyStub: (_ defaultName: String) -> [String: Any]? = { _ in UserDefaultsMock.fail(); return nil }

	override func dictionary(forKey defaultName: String) -> [String: Any]? {
		return dictionaryForKeyStub(defaultName)
	}

	var dataForKeyStub: (_ defaultName: String) -> Data? = { _ in UserDefaultsMock.fail(); return nil }

	override func data(forKey defaultName: String) -> Data? {
		return dataForKeyStub(defaultName)
	}

	var boolForKeyStub: (_ defaultName: String) -> Bool = { _ in UserDefaultsMock.fail(); return false }

	override func bool(forKey defaultName: String) -> Bool {
		return boolForKeyStub(defaultName)
	}

	var integerForKeyStub: (_ defaultName: String) -> Int = { _ in UserDefaultsMock.fail(); return 0 }

	override func integer(forKey defaultName: String) -> Int {
		return integerForKeyStub(defaultName)
	}

	var floatForKeyStub: (_ defaultName: String) -> Float = { _ in UserDefaultsMock.fail(); return 0.0 }

	override func float(forKey defaultName: String) -> Float {
		return floatForKeyStub(defaultName)
	}

	var doubleForKeyStub: (_ defaultName: String) -> Double = { _ in UserDefaultsMock.fail(); return 0.0 }

	override func double(forKey defaultName: String) -> Double {
		return doubleForKeyStub(defaultName)
	}

	var dictionaryRepresentationStub: () -> [String: Any] = { UserDefaultsMock.fail(); return [:] }

	override func dictionaryRepresentation() -> [String: Any] {
		return dictionaryRepresentationStub()
	}

	// MARK: - Setting Default Values

	var setValueStub: (_ value: Any?, _ defaultName: String) -> Void = { _, _ in UserDefaultsMock.fail() }

	override func set(_ value: Any?, forKey defaultName: String) {
		setValueStub(value, defaultName)
	}

	var setFloatStub: (_ value: Float, _ defaultName: String) -> Void = { _, _ in UserDefaultsMock.fail() }

	override func set(_ value: Float, forKey defaultName: String) {
		setFloatStub(value, defaultName)
	}

	var setDoubleStub: (_ value: Double, _ defaultName: String) -> Void = { _, _ in UserDefaultsMock.fail() }

	override func set(_ value: Double, forKey defaultName: String) {
		setDoubleStub(value, defaultName)
	}

	var setIntStub: (_ value: Int, _ defaultName: String) -> Void = { _, _ in UserDefaultsMock.fail() }

	override func set(_ value: Int, forKey defaultName: String) {
		setIntStub(value, defaultName)
	}

	var setBoolStub: (_ value: Bool, _ defaultName: String) -> Void = { _, _ in UserDefaultsMock.fail() }

	override func set(_ value: Bool, forKey defaultName: String) {
		setBoolStub(value, defaultName)
	}

	var setUrlStub: (_ value: URL?, _ defaultName: String) -> Void = { _, _ in UserDefaultsMock.fail() }

	override func set(_ url: URL?, forKey defaultName: String) {
		setUrlStub(url, defaultName)
	}

	// MARK: - Removing Defaults

	var removeObjectForKeyStub: (_ defaultName: String) -> Void = { _ in UserDefaultsMock.fail() }

	override func removeObject(forKey defaultName: String) {
		removeObject(forKey: defaultName)
	}

	// MARK: - Maintaining Suites

	var addSuiteNamedStub: (_ suiteName: String) -> Void = { _ in UserDefaultsMock.fail() }

	override func addSuite(named suiteName: String) {
		addSuiteNamedStub(suiteName)
	}

	var removeSuiteNamedStub: (_ suiteName: String) -> Void = { _ in UserDefaultsMock.fail() }

	override func removeSuite(named suiteName: String) {
		removeSuiteNamedStub(suiteName)
	}

	// MARK: - Registering Defaults

	var registerDefaultsStub: (_ registrationDictionary: [String: Any]) -> Void = { _ in UserDefaultsMock.fail() }

	override func register(defaults registrationDictionary: [String: Any]) {
		registerDefaultsStub(registrationDictionary)
	}

	// MARK: - Legacy

	var synchronizeStub: () -> Bool = {
		// Normally we don't care about this, but we allow it.
		true
	}

	override func synchronize() -> Bool {
		return synchronizeStub()
	}
}
