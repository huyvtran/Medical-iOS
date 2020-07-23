@testable import Makula
import XCTest

class NavigationViewTests: TestCase {
	// MARK: - Setup

	var sut: NavigationView!

	override func setUp() {
		super.setUp()

		sut = NavigationView()
		sut.addWidthConstraint(withWidth: 320)

		sut.title = "Title"
		sut.leftButtonVisible = true
		sut.largeStyle = false
		sut.separatorVisible = true
	}

	override func tearDown() {
		sut = nil
		super.tearDown()
	}

	// MARK: - Tests

	/// The view with default values.
	func testDefault() {
		assertSnapshot(view: sut, record: false, deviceAgnostic: false)
	}

	/// The view without a title.
	func testNoTitle() {
		sut.title = ""
		assertSnapshot(view: sut, record: false, deviceAgnostic: false)
	}

	/// The view with a very long title.
	func testLongTitle() {
		sut.title = "A very very long title which should not fit in one line."
		assertSnapshot(view: sut, record: false, deviceAgnostic: false)
	}

	/// The view with no back button.
	func testNoBackButton() {
		sut.leftButtonVisible = false
		assertSnapshot(view: sut, record: false, deviceAgnostic: false)
	}

	/// The view in large mode.
	func testLargeFont() {
		sut.largeStyle = true
		assertSnapshot(view: sut, record: false, deviceAgnostic: false)
	}

	/// The view without the separator.
	func testHiddenSeparator() {
		sut.separatorVisible = false
		assertSnapshot(view: sut, record: false, deviceAgnostic: false)
	}
}
