import UIKit

/**
 The router for this scene responsible for transitioning to other scenes.
 */
class VisusNhdInputRouter {
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

// MARK: - VisusNhdInputRouterInterface

extension VisusNhdInputRouter: VisusNhdInputRouterInterface {
	func routeBack() {
		// Pop back via nav controller.
		guard let navController = viewController?.navigationController else {
			fatalError("Navigation controller expected")
		}
		navController.popViewController(animated: true)
	}

	func routeToGraph(model: GraphRouterModel.Setup) {
		// Push a new scene onto the nav controller.
		guard let navController = viewController?.navigationController else {
			fatalError("Navigation controller expected")
		}
		let scene = GraphDisplay()
		scene.setup(model: model)
		navController.pushViewController(scene, animated: true)
	}

	func routeToInformation(model: InfoRouterModel.Setup) {
		// Push scene onto the nav controller.
		guard let navController = viewController?.navigationController else {
			fatalError("Navigation controller expected")
		}
		let scene = InfoDisplay()
		scene.setup(model: model)
		navController.pushViewController(scene, animated: true)
	}
}
