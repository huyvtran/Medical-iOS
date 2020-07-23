import UIKit

/**
 The view controller which represents the display.

 Its purpose is to hold references to the logic and any views in the scene.
 It is responsible for displaying data provided by the logic by manipulating the view.
 The view controller does NOT manage the routing to other scenes, this is the purpose of the router which is called by the logic.
 The view controller is NOT responsible for any logic beyond formatting the output.
 */
class DisclaimerDisplay: BaseViewController {
	// MARK: - Dependencies

	/// The reference to the logic.
	private var logic: DisclaimerLogicInterface?

	/// The factory method which creates the logic for this display during setup.
	var createLogic: (DisclaimerDisplayInterface, UIViewController) -> DisclaimerLogicInterface = { display, viewController in
		DisclaimerLogic(display: display, router: DisclaimerRouter(viewController: viewController))
	}

	// MARK: - Setup

	/**
	 Sets up the instance with a new model.
	 Creates the logic if needed.

	 Has to be called before presenting the view controller.

	 - parameter model: The parameters for setup.
	 */
	func setup(model: DisclaimerRouterModel.Setup) {
		// Set up Logic.
		if logic == nil {
			logic = createLogic(self, self)
		}
		logic?.setModel(model)
	}

	// MARK: - View

	/// The root view of this controller. Only defined after the controller's view has been loaded.
	private var rootView: DisclaimerView! { return view as? DisclaimerView }

	override func loadView() {
		guard let logic = logic else { fatalError("Logic instance expected") }
		view = DisclaimerView(logic: logic)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		// Request initial display data.
		logic?.requestDisplayData()
	}

	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		coordinator.animate(alongsideTransition: { _ in
		}, completion: { _ in
			self.logic?.requestDisplayData()
		})
		super.viewWillTransition(to: size, with: coordinator)
	}
}

// MARK: - DisclaimerDisplayInterface

extension DisclaimerDisplay: DisclaimerDisplayInterface {
	func updateDisplay(model: DisclaimerDisplayModel.UpdateDisplay) {
		// Update the view.
		rootView.largeStyle = model.largeStyle
	}

	func updateConfirmButton(enabled: Bool) {
		rootView.confirmButtonEnabled = enabled
	}
}
