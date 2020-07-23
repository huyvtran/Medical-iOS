import UIKit

/**
 The view controller which represents the display.

 Its purpose is to hold references to the logic and any views in the scene.
 It is responsible for displaying data provided by the logic by manipulating the view.
 The view controller does NOT manage the routing to other scenes, this is the purpose of the router which is called by the logic.
 The view controller is NOT responsible for any logic beyond formatting the output.
 */
class InfoDisplay: BaseViewController {
	// MARK: - Dependencies

	/// The reference to the logic.
	private var logic: InfoLogicInterface?

	/// The factory method which creates the logic for this display during setup.
	var createLogic: (InfoDisplayInterface, UIViewController) -> InfoLogicInterface = { display, viewController in
		InfoLogic(display: display, router: InfoRouter(viewController: viewController))
	}

	// MARK: - Setup

	/**
	 Sets up the instance with a new model.
	 Creates the logic if needed.

	 Has to be called before presenting the view controller.

	 - parameter model: The parameters for setup.
	 */
	func setup(model: InfoRouterModel.Setup) {
		// Set up Logic.
		if logic == nil {
			logic = createLogic(self, self)
		}
		logic?.setModel(model)
	}

	// MARK: - View

	/// The root view of this controller. Only defined after the controller's view has been loaded.
	private var rootView: InfoView! { return view as? InfoView }

	override func loadView() {
		guard let logic = logic else { fatalError("Logic instance expected") }
		view = InfoView(logic: logic)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		logic?.requestDisplayData()
		rootView.bringContentToTop()
	}

	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		coordinator.animate(alongsideTransition: { _ in
		}, completion: { _ in
			self.logic?.requestDisplayData()
		})
		super.viewWillTransition(to: size, with: coordinator)
	}
}

// MARK: - InfoDisplayInterface

extension InfoDisplay: InfoDisplayInterface {
	func updateDisplay(model: InfoDisplayModel.UpdateDisplay) {
		// Update the view.
		rootView.largeStyle = model.largeStyle
		rootView.navigationViewHidden = model.largeStyle
		rootView.navigationViewTitle = model.sceneType.titleString()
		rootView.contentText = model.sceneType.contentString()
		rootView.bringContentToTop()

		// Scene dependings.
		switch model.sceneType {
		case .backup:
			rootView.bottomButtonText = R.string.info.backupButtonTitle()
			rootView.bottomButtonVisible = true
		default:
			break
		}
	}

	func setBottomButtonVisible(_ visible: Bool) {
		rootView.bottomButtonVisible = visible
	}

	func showError(title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let cancelAction = UIAlertAction(title: R.string.global.defaultErrorConfirmButton(), style: .cancel, handler: nil)
		alert.addAction(cancelAction)
		present(alert, animated: true, completion: nil)
	}

	func presentMail(controller: UIViewController) {
		present(controller, animated: true)
	}
}
