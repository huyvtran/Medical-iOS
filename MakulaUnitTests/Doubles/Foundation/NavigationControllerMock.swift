import UIKit
import XCTest

/// A testing mock for when something depends on `UINavigationController`.
class NavigationControllerMock: UINavigationController {
	// MARK: - Mock

	private static var file: StaticString = ""
	private static var line: UInt = 0

	/**
	 Instantiates the mock and saves the code file and line where this happens.

	 - parameter file: The file, don't provide anything.
	 - parameter line: The line number, don't provide anything.
	 */
	convenience init(file: StaticString = #file, line: UInt = #line) {
		NavigationControllerMock.file = file
		NavigationControllerMock.line = line
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
		XCTFail(file: NavigationControllerMock.file, line: NavigationControllerMock.line)
	}

	// MARK: -

	var pushViewControllerStub: (_ viewController: UIViewController, _ animated: Bool) -> Void = { _, _ in NavigationControllerMock.fail() }

	override func pushViewController(_ viewController: UIViewController, animated: Bool) {
		pushViewControllerStub(viewController, animated)
	}

	// MARK: -

	var popViewControllerStub: (_ animated: Bool) -> UIViewController? = { _ in NavigationControllerMock.fail(); return nil }

	override func popViewController(animated: Bool) -> UIViewController? {
		return popViewControllerStub(animated)
	}
}
