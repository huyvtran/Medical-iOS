import UIKit

/// The delegate of a `KeyboardController` which gets informed about keyboard appearance changes.
protocol KeyboardControllerDelegate: class {
	/**
	 The keyboard currently shows in.

	 - parameter keyboardSize: The keyboard's size.
	 */
	func keyboardShows(keyboardSize: CGSize)

	/**
	 The keyboard has shown up. Showing in has finished.
	 */
	func keyboardShown()

	/**
	 The keyboard currently hides by moving out of view.
	 */
	func keyboardHides()

	/**
	 The keyboard has hidden. Hiding has finished.
	 */
	func keyboardHidden()
}
