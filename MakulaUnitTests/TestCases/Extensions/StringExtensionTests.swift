@testable import Makula
import XCTest

class StringExtensionTests: TestCase {
	// MARK: - Setup

	/// The string under test.
	var sut: String!

	// MARK: - Tests

	// MARK: Truncated

	/// Truncating the empty string remains an empty string.
	func testTruncateEmptyString() {
		// Given
		sut = String.empty
		let numberOfCharsToTruncate = 5

		// When
		let result = sut.truncated(numberOfCharacters: numberOfCharsToTruncate)

		// Then
		XCTAssertEqual("", result)
	}

	/// Truncating a string which would fit fully doesn't get truncated.
	func testTruncateShortString() {
		// Given
		sut = "ABCD"
		let numberOfCharsToTruncate = 5

		// When
		let result = sut.truncated(numberOfCharacters: numberOfCharsToTruncate)

		// Then
		XCTAssertEqual("ABCD", result)
	}

	/// The string remains untruncated when it would fit fully into the number of chars.
	func testTruncateFittingString() {
		// Given
		sut = "ABCDE"
		let numberOfCharsToTruncate = 5

		// When
		let result = sut.truncated(numberOfCharacters: numberOfCharsToTruncate)

		// Then
		XCTAssertEqual("ABCDE", result)
	}

	/// The string gets truncated when too long.
	func testTruncateLongString() {
		// Given
		sut = "ABCDEF"
		let numberOfCharsToTruncate = 5

		// When
		let result = sut.truncated(numberOfCharacters: numberOfCharsToTruncate)

		// Then
		XCTAssertEqual("AB...", result)
	}

	/// The three dots get skipped when they wouldn't fit into the truncated string.
	func testTruncateTooManyChars() {
		// Given
		sut = "ABCDE"
		let numberOfCharsToTruncate = 2

		// When
		let result = sut.truncated(numberOfCharacters: numberOfCharsToTruncate)

		// Then
		XCTAssertEqual("AB", result)
	}
}
