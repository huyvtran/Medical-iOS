/// The router interface provided to the logic to make all possible routes from this scene to others available.
protocol ContactRouterInterface: class {
	/**
	 Routes back to the previous (root) menu scene on the navigation stack.
	 */
	func routeBackToMenu()

	/**
	 Routes to the contact details scene by pushing it onto the navigation stack.

	 - parameter model: The model for scene setup.
	 */
	func routeToContactDetails(model: ContactDetailsRouterModel.Setup)
}
