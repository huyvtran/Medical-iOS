/// The router interface provided to the logic to make all possible routes from this scene to others available.
protocol AppointmentDetailRouterInterface: class {
	/**
	 Routes back to the previous scene on the navigation stack.
	 */
	func routeBack()

	/**
	 Routes to the note scene by pushing it onto the navigation stack.

	 - parameter model: The model for scene setup.
	 */
	func routeToNote(model: NoteRouterModel.Setup)
}
