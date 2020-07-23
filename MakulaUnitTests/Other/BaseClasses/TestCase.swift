import FBSnapshotTestCase
@testable import Makula
import XCTest

/**
 The base class for Test Cases for Unit testing.
 Classes should derive from this instead of `XCTestCase`.

 Supports the `FBSnapshotTestCase` to make snapshot tests.
 */
class TestCase: FBSnapshotTestCase {
	// MARK: - Snapshots

	/// If set, this value will override any set `record` parameters in `assertSnapshot` calls.
	/// Defaults to `nil` so the parameter values are used, except the user defined build setting `CREATE_SCREENSHOTS` is set in which case this becomes `true`.
	/// Set to `true` to force all UI tests to create new snapshot files.
	static var overriddenRecordMode: Bool? = {
		#if CREATE_SNAPSHOTS
			return true
		#else
			return nil
		#endif
	}()

	/// If set, this value will override any set `deviceAgnostic` parameters in `assertSnapshot` calls.
	/// Defaults to `nil` so the parameter values are used, except the user defined build setting `DEVICE_AGNOSTIC_SCREENSHOTS` is set in which case this becomes `true`.
	/// Set to `true` to force all UI tests to create device agnostic snapshot file names.
	static var overriddenDeviceAgnostic: Bool? = {
		#if DEVICE_AGNOSTIC_SCREENSHOTS
			return true
		#else
			return nil
		#endif
	}()

	/**
	 Asserts that the given view equals to its snapshot reference.
	 The reference name equals to the test method's name which calls this assert method.

	 - parameter view: The view to verify.
	 - parameter record: Sets the `FBSnapshotTestCase`'s `recordMode`.
	 Set to `true` to create the snapshot instead of comparing, but this fails the test.
	 Set to `false` to compare the snapshot with the saved one from disc which only fails when the snapshot doesn't match or is not present.
	 - parameter deviceAgnostic: When `true` appends the iOS version to the snapshot file name to make the test case work on different OS versions.
	 Set to `false` to ignore the device's size, e.g. the view is display size independent.
	 - parameter file: The file name which calls this code. Don't set a value.
	 - parameter line: The line number where this code has been called. Don't set a value.
	 */
	func assertSnapshot(
		view: UIView,
		record: Bool,
		deviceAgnostic: Bool,
		file: StaticString = #file,
		line: UInt = #line
	) {
		recordMode = TestCase.overriddenRecordMode ?? record
		let deviceAgnosticMode = TestCase.overriddenDeviceAgnostic ?? deviceAgnostic
		let identifier = deviceAgnosticMode ? "(\(UIDevice.current.systemVersion))" : ""
		FBSnapshotVerifyView(view, identifier: identifier, suffixes: [""], file: file, line: line)
	}
}
