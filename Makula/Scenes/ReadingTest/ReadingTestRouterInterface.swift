/// The router interface provided to the logic to make all possible routes from this scene to others available.
protocol ReadingTestRouterInterface: class {
	/**
	 Routes back to the previous menu scene on the navigation stack.
	 */
	func routeBackToMenu()

	/**
	 Routes to the information scene by pushing it onto the navigation stack.

	 - parameter model: The model for scene setup.
	 */
	func routeToInformation(model: InfoRouterModel.Setup)
}
