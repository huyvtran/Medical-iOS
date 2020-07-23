/// The router interface provided to the logic to make all possible routes from this scene to others available.
protocol DisclaimerRouterInterface: class {
	/**
	 Routes to the menu scene.

	 - parameter model: The model for setup the menu scene.
	 */
	func routeToMenu(model: MenuRouterModel.Setup)
}
