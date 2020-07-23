import UIKit

/**
 The view controller which represents the display.

 Its purpose is to hold references to the logic and any views in the scene.
 It is responsible for displaying data provided by the logic by manipulating the view.
 The view controller does NOT manage the routing to other scenes, this is the purpose of the router which is called by the logic.
 The view controller is NOT responsible for any logic beyond formatting the output.
 */
class SplashDisplay: BaseViewController {
	// MARK: - Dependencies

	/// The reference to the logic.
	private var logic: SplashLogicInterface?

	/// The factory method which creates the logic for this display during setup.
	var createLogic: (SplashDisplayInterface, UIViewController) -> SplashLogicInterface = { display, viewController in
		SplashLogic(display: display, router: SplashRouter(viewController: viewController))
	}

	// MARK: - Setup

	/**
	 Sets up the instance with a new model.
	 Creates the logic if needed.

	 Has to be called before presenting the view controller.

	 - parameter model: The parameters for setup.
	 */
	func setup(model: SplashRouterModel.Setup) {
		// Set up Logic
		if logic == nil {
			logic = createLogic(self, self)
		}
		logic?.setModel(model)
	}

	// MARK: - View

	/// The root view of this controller. Only defined after the controller's view has been loaded.
	private var rootView: SplashView! { return view as? SplashView }

	override func loadView() {
		guard let logic = logic else { fatalError("Logic instance expected") }
		view = SplashView(logic: logic)

		// Hide the logo on load.
		rootView.logoVisible = false
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		// Request initial display data.
		guard let logic = logic else { fatalError("Logic instance expected") }
		logic.requestDisplayData()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		// Fade in the logo.
		fadeInLogo()
	}

	/**
	 Makes the logo fade in with an animation.
	 */
	private func fadeInLogo() {
		UIView.animate(withDuration: Const.Splash.Time.logoFadeInDuration, delay: 0, options: .curveEaseInOut, animations: {
			self.rootView.logoVisible = true
		}, completion: nil)
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		// Initiate routing to the menu scene.
		guard let logic = logic else { fatalError("Logic instance expected") }
		logic.processForTransition()
	}

	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		coordinator.animate(alongsideTransition: { _ in
		}, completion: { _ in
			self.logic?.requestDisplayData()
		})
		super.viewWillTransition(to: size, with: coordinator)
	}
}

// MARK: - SplashDisplayInterface

extension SplashDisplay: SplashDisplayInterface {
	func updateDisplay(model: SplashDisplayModel.UpdateDisplay) {
		// Update the view.
	}

	func showDatabaseError() {
		// Show alert with appropriate information.
		let alert = UIAlertController(
			title: R.string.splash.databaseTouchErrorTitle(),
			message: R.string.splash.databaseTouchErrorMessage(),
			preferredStyle: .alert
		)
		let confirmAction = UIAlertAction(
			title: R.string.splash.databaseTouchErrorConfirmButton(),
			style: .default,
			handler: nil
		)
		alert.addAction(confirmAction)
		present(alert, animated: true)
	}
}
