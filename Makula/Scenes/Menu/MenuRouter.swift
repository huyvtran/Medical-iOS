import UIKit

/**
 The router for this scene responsible for transitioning to other scenes.
 */
class MenuRouter {
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

// MARK: - MenuRouterInterface

extension MenuRouter: MenuRouterInterface {
	func routeToMenu(model: MenuRouterModel.Setup) {
		// Push a new menu scene onto the nav controller.
		guard let navController = viewController?.navigationController else {
			fatalError("Navigation controller expected")
		}
		let scene = MenuDisplay()
		scene.setup(model: model)
		navController.pushViewController(scene, animated: true)
	}

	func routeToNewAppointment(model: NewAppointmentRouterModel.Setup) {
		// Push a new appointment scene onto the nav controller.
		guard let navController = viewController?.navigationController else {
			fatalError("Navigation controller expected")
		}
		let scene = NewAppointmentDisplay()
		scene.setup(model: model)
		navController.pushViewController(scene, animated: true)
	}

	func routeToContact(model: ContactRouterModel.Setup) {
		// Push a contact scene onto the nav controller.
		guard let navController = viewController?.navigationController else {
			fatalError("Navigation controller expected")
		}
		let scene = ContactDisplay()
		scene.setup(model: model)
		navController.pushViewController(scene, animated: true)
	}

	func routeToDiagnosis(model: DiagnosisRouterModel.Setup) {
		// Push a diagnosis scene onto the nav controller.
		guard let navController = viewController?.navigationController else {
			fatalError("Navigation controller expected")
		}
		let scene = DiagnosisDisplay()
		scene.setup(model: model)
		navController.pushViewController(scene, animated: true)
	}

	func routeToMedicament(model: MedicamentRouterModel.Setup) {
		// Push a medicament scene onto the nav controller.
		guard let navController = viewController?.navigationController else {
			fatalError("Navigation controller expected")
		}
		let scene = MedicamentDisplay()
		scene.setup(model: model)
		navController.pushViewController(scene, animated: true)
	}

	func routeToVisusNhdInput(model: VisusNhdInputRouterModel.Setup) {
		// Push scene onto the nav controller.
		guard let navController = viewController?.navigationController else {
			fatalError("Navigation controller expected")
		}
		let scene = VisusNhdInputDisplay()
		scene.setup(model: model)
		navController.pushViewController(scene, animated: true)
	}

	func routeToCalendar(model: CalendarRouterModel.Setup) {
		// Push scene onto the nav controller.
		guard let navController = viewController?.navigationController else {
			fatalError("Navigation controller expected")
		}
		let scene = CalendarDisplay()
		scene.setup(model: model)
		navController.pushViewController(scene, animated: true)
	}

	func routeToAmslertest(model: AmslertestRouterModel.Setup) {
		// Push scene onto the nav controller.
		guard let navController = viewController?.navigationController else {
			fatalError("Navigation controller expected")
		}
		let scene = AmslertestDisplay()
		scene.setup(model: model)
		navController.pushViewController(scene, animated: true)
	}

	func routeToReadingTest(model: ReadingTestRouterModel.Setup) {
		// Push scene onto the nav controller.
		guard let navController = viewController?.navigationController else {
			fatalError("Navigation controller expected")
		}
		let scene = ReadingTestDisplay()
		scene.setup(model: model)
		navController.pushViewController(scene, animated: true)
	}

	func routeToGraph(model: GraphRouterModel.Setup) {
		// Push scene onto the nav controller.
		guard let navController = viewController?.navigationController else {
			fatalError("Navigation controller expected")
		}
		let scene = GraphDisplay()
		scene.setup(model: model)
		navController.pushViewController(scene, animated: true)
	}

	func routeToAppointmentDetail(model: AppointmentDetailRouterModel.Setup) {
		// Push the new scene onto the nav controller.
		guard let navController = viewController?.navigationController else {
			fatalError("Navigation controller expected")
		}
		let scene = AppointmentDetailDisplay()
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

	func routeToSearch(model: SearchRouterModel.Setup) {
		// Push scene onto the nav controller.
		guard let navController = viewController?.navigationController else {
			fatalError("Navigation controller expected")
		}
		let scene = SearchDisplay()
		scene.setup(model: model)
		navController.pushViewController(scene, animated: true)
	}

	func routeToReminder(model: ReminderRouterModel.Setup) {
		// Push scene onto the nav controller.
		guard let navController = viewController?.navigationController else {
			fatalError("Navigation controller expected")
		}
		let scene = ReminderDisplay()
		scene.setup(model: model)
		navController.pushViewController(scene, animated: true)
	}

	func routeBackToMenu() {
		// Pop back via nav controller.
		guard let navController = viewController?.navigationController else {
			fatalError("Navigation controller expected")
		}
		navController.popViewController(animated: true)
	}
}
