import UIKit

/**
 The view controller which represents the display.

 Its purpose is to hold references to the logic and any views in the scene.
 It is responsible for displaying data provided by the logic by manipulating the view.
 The view controller does NOT manage the routing to other scenes, this is the purpose of the router which is called by the logic.
 The view controller is NOT responsible for any logic beyond formatting the output.
 */
class VisusNhdInputDisplay: BaseViewController {
	// MARK: - Dependencies

	/// The reference to the logic.
	private var logic: VisusNhdInputLogicInterface?

	/// The factory method which creates the logic for this display during setup.
	var createLogic: (VisusNhdInputDisplayInterface, UIViewController) -> VisusNhdInputLogicInterface = { display, viewController in
		VisusNhdInputLogic(display: display, router: VisusNhdInputRouter(viewController: viewController))
	}

	/// The delegate controller for the table view.
	private var tableController: VisusNhdInputTableControllerInterface?

	/// The factory method which creates the table controller when the view gets loaded.
	var createTableController: (UITableView, VisusNhdInputLogicInterface) -> VisusNhdInputTableControllerInterface = { tableview, logic in
		VisusNhdInputTableController(tableView: tableview, logic: logic)
	}

	// MARK: - Setup

	/**
	 Sets up the instance with a new model.
	 Creates the logic if needed.

	 Has to be called before presenting the view controller.

	 - parameter model: The parameters for setup.
	 */
	func setup(model: VisusNhdInputRouterModel.Setup) {
		// Set up Logic.
		if logic == nil {
			logic = createLogic(self, self)
		}
		logic?.setModel(model)
	}

	// MARK: - View

	/// The root view of this controller. Only defined after the controller's view has been loaded.
	private var rootView: VisusNhdInputView! { return view as? VisusNhdInputView }

	override func loadView() {
		guard let logic = logic else { fatalError("Logic instance expected") }
		view = VisusNhdInputView(logic: logic)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		// Create table controller.
		guard let logic = logic else { fatalError("Logic instance expected") }
		tableController = createTableController(rootView.tableView, logic)
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

// MARK: - VisusNhdInputDisplayInterface

extension VisusNhdInputDisplay: VisusNhdInputDisplayInterface {
	func updateDisplay(model: VisusNhdInputDisplayModel.UpdateDisplay) {
		// Update the navigation view.
		rootView.navigationViewHidden = model.largeStyle
		rootView.title = model.sceneType.visusNhdInputTitleString()
		rootView.largeStyle = model.largeStyle

		// Update table view.
		tableController?.setData(model: model)
	}

	func updateValueTitle(model: VisusNhdInputDisplayModel.UpdateValueTitle) {
		tableController?.updateValueTitle(model: model)
	}

	func showDatabaseWriteError() {
		let alert = UIAlertController(
			title: R.string.global.databaseWriteErrorTitle(),
			message: R.string.global.databaseWriteErrorMessage(),
			preferredStyle: .alert
		)
		let confirmAction = UIAlertAction(
			title: R.string.global.databaseWriteErrorCancelButton(),
			style: .default,
			handler: nil
		)
		alert.addAction(confirmAction)
		present(alert, animated: true)
	}

	func enableConfirmButton() {
		rootView.confirmButtonEnabled = true
	}
}
