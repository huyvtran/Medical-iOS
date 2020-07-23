/// The display interface, which is available to the logic for updating the views.
protocol DisclaimerDisplayInterface: class {
	/**
	 Updates the display with given data to show.

	 - parameter model: The data to show.
	 */
	func updateDisplay(model: DisclaimerDisplayModel.UpdateDisplay)

	/**
	 Updates the confirm button's enabled state.

	 - parameter enabled: Set to `true` to enable the confirm button, `false` to disable it.
	 */
	func updateConfirmButton(enabled: Bool)
}
