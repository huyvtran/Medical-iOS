@testable import Makula
import XCTest

/// A base class for mocks from where mocking classes should derive from.
class BaseMock: NSObject {
	/// A position in code with file and line.
	private struct Position {
		let file: StaticString
		let line: UInt
	}

	/// All code positions where instances of this class has been instantiated.
	private static var positions = [String: Position]()

	/**
	 Instantiates a mock and saves the code file and line where this happens.

	 - parameter file: The file, don't provide anything.
	 - parameter line: The line number, don't provide anything.
	 */
	init(file: StaticString = #file, line: UInt = #line) {
		super.init()
		let className = String(describing: type(of: self))
		BaseMock.positions[className] = Position(file: file, line: line)
	}

	/**
	 Fails the current running test and points to the locations where this has been called and where the mock has been instantiated.

	 Should only be called in closures where the function's name is equal to the class.

	 - parameter function: The function's name where this is called, don't provide anything.
	 - parameter file: The file, don't provide anything.
	 - parameter line: The line number, don't provide anything.
	 */
	static func fail(function: StaticString = #function, file: StaticString = #file, line: UInt = #line) {
		// Fail in the line where this method is beeing called.
		XCTFail(file: file, line: line)
		// Fail also at the location where the mock has been instantiated.
		let className = String(describing: function) // In closures this is the classes name.
		guard let position = BaseMock.positions[className] else {
			fatalError("Position not found for this instance")
		}
		XCTFail(file: position.file, line: position.line)
	}
}
