/// The router interface provided to the logic to make all possible routes from this scene to others available.
protocol VisusNhdInputRouterInterface: class {
	/**
	 Routes back to the previous scene on the navigation stack.
	 */
	func routeBack()

	/**
	 Routes to the graph scene with manipulating the navigation stack.

	 - parameter model: The model for scene setup.
	 */
	func routeToGraph(model: GraphRouterModel.Setup)

	/**
	 Routes to the information scene by pushing it onto the navigation stack.

	 - parameter model: The model for scene setup.
	 */
	func routeToInformation(model: InfoRouterModel.Setup)
}
