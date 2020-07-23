import UIKit

/**
 The router for this scene responsible for transitioning to other scenes.
 */
class ContactRouter {
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

// MARK: - ContactRouterInterface

extension ContactRouter: ContactRouterInterface {
	func routeBackToMenu() {
		// Pop back via nav controller.
		guard let navController = viewController?.navigationController else {
			fatalError("Navigation controller expected")
		}
		navController.popViewController(animated: true)
	}

	func routeToContactDetails(model: ContactDetailsRouterModel.Setup) {
		// Push a medicament scene onto the nav controller.
		guard let navController = viewController?.navigationController else {
			fatalError("Navigation controller expected")
		}
		let scene = ContactDetailsDisplay()
		scene.setup(model: model)
		navController.pushViewController(scene, animated: true)
	}
}
