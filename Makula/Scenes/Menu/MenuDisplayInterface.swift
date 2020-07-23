import Foundation

/// The display interface, which is available to the logic for updating the views.
protocol MenuDisplayInterface: class {
	/**
	 Updates the display with given data to show.

	 - parameter model: The data to show.
	 */
	func updateDisplay(model: MenuDisplayModel.UpdateDisplay)

	/**
	 Scrolls the table view to the first cell in the table view.
	 */
	func scrollToTop()

	/**
	 Highlights / De-highlights the cell represented by a given speech data model.

	 - parameter speechData: The speech data model.
	 - parameter highlight: Whether the cell should get highlighted (`true`) or de-highlighted (`false`).
	 */
	func setHighlightCell(for speechData: SpeechData, highlight: Bool)
}
