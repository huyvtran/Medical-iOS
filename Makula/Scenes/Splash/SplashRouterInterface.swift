protocol SplashRouterInterface: class {
	/**
	 Routes to the menu scene.

	 - parameter model: The model for setup the scene.
	 */
	func routeToMenu(model: MenuRouterModel.Setup)

	/**
	 Routes to the disclaimer scene.

	 - parameter model: The model for setup the scene.
	 */
	func routeToDisclaimer(model: DisclaimerRouterModel.Setup)
}
