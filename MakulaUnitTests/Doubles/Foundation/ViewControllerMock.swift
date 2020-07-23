import UIKit
import XCTest

/// A testing mock for when something depends on `UIViewController`.
class ViewControllerMock: UIViewController {
	// MARK: - Mock

	private static var file: StaticString = ""
	private static var line: UInt = 0

	/**
	 Instantiates the mock and saves the code file and line where this happens.

	 - parameter file: The file, don't provide anything.
	 - parameter line: The line number, don't provide anything.
	 */
	convenience init(file: StaticString = #file, line: UInt = #line) {
		ViewControllerMock.file = file
		ViewControllerMock.line = line
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
		XCTFail(file: ViewControllerMock.file, line: ViewControllerMock.line)
	}

	// MARK: -

	var presentViewControllerStub: (
		_ viewController: UIViewController,
		_ animated: Bool,
		_ completion: (() -> Void)?
	) -> Void = { _, _, _ in
		ViewControllerMock.fail()
	}

	override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
		presentViewControllerStub(viewControllerToPresent, flag, completion)
	}

	// MARK: -

	var navigationControllerGetStub: () -> UINavigationController? = { ViewControllerMock.fail(); return nil }

	var navigationControllerSetStub: (_ value: UINavigationController?) -> Void = { _ in ViewControllerMock.fail() }

	override var navigationController: UINavigationController? {
		get {
			return navigationControllerGetStub()
		}
		set {
			navigationControllerSetStub(newValue)
		}
	}
}
