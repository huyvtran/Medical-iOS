import Hero
import UIKit

/**
 The router for this scene responsible for transitioning to other scenes.
 */
class SplashRouter {
	// MARK: - Dependencies

	/// The current view controller which is displayed and this router performs transitions on.
	private(set) weak var viewController: UIViewController?

	// MARK: - Init

	/**
	 Inititalizes a router class with its view controller.

	 - parameter viewController: The view controller on which this router operates.
	 */
	init(viewController: UIViewController) {
		self.viewController = viewController
	}
}

// MARK: - SplashRouterInterface

extension SplashRouter: SplashRouterInterface {
	func routeToMenu(model: MenuRouterModel.Setup) {
		// Create menu scene in a nav controller.
		let scene = MenuDisplay()
		scene.setup(model: model)
		let navController = UINavigationController(rootViewController: scene)
		navController.isNavigationBarHidden = true

		// Use a fade animation for the transition.
		scene.hero.isEnabled = true
		scene.hero.modalAnimationType = .fade
		viewController?.hero.replaceViewController(with: navController)
	}

	func routeToDisclaimer(model: DisclaimerRouterModel.Setup) {
		// Create disclaimer scene.
		let scene = DisclaimerDisplay()
		scene.setup(model: model)

		// Use a fade animation for the transition.
		scene.hero.isEnabled = true
		scene.hero.modalAnimationType = .fade
		viewController?.hero.replaceViewController(with: scene)
	}
}
