import UIKit

/**
 The view controller which represents the display.

 Its purpose is to hold references to the logic and any views in the scene.
 It is responsible for displaying data provided by the logic by manipulating the view.
 The view controller does NOT manage the routing to other scenes, this is the purpose of the router which is called by the logic.
 The view controller is NOT responsible for any logic beyond formatting the output.
 */
class MenuDisplay: BaseViewController {
	// MARK: - Dependencies

	/// The reference to the logic.
	private var logic: MenuLogicInterface?

	/// The factory method which creates the logic for this display during setup.
	var createLogic: (MenuDisplayInterface, UIViewController) -> MenuLogicInterface = { display, viewController in
		MenuLogic(display: display, router: MenuRouter(viewController: viewController))
	}

	/// The delegate controller for the table view.
	private var tableController: MenuTableControllerInterface?

	/// The factory method which creates the table controller when the view gets loaded.
	var createTableController: (UITableView, MenuLogicInterface) -> MenuTableControllerInterface = { tableView, logic in
		MenuTableController(tableView: tableView, logic: logic)
	}

	// MARK: - Setup

	/**
	 Sets up the instance with a new model.
	 Creates the logic if needed.

	 Has to be called before presenting the view controller.

	 - parameter model: The parameters for setup.
	 */
	func setup(model: MenuRouterModel.Setup) {
		// Set up Logic.
		if logic == nil {
			logic = createLogic(self, self)
		}
		logic?.setModel(model)
	}

	// MARK: - View

	/// The root view of this controller. Only defined after the controller's view has been loaded.
	private var rootView: MenuView! { return view as? MenuView }

	override func loadView() {
		guard let logic = logic else { fatalError("Logic instance expected") }
		view = MenuView(logic: logic)
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

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		tableController?.updateFooterSize()
	}
}

// MARK: - MenuDisplayInterface

extension MenuDisplay: MenuDisplayInterface {
	func updateDisplay(model: MenuDisplayModel.UpdateDisplay) {
		// Update navigation view.
		rootView.navigationViewHidden = model.largeStyle
		rootView.backButtonVisible = !model.isRoot
		rootView.navigationViewTitle = model.sceneId.titleString()

		// Update table view.
		tableController?.setData(model: model)
	}

	func scrollToTop() {
		tableController?.scrollToTop()
	}

	func setHighlightCell(for speechData: SpeechData, highlight: Bool) {
		guard let indexPath = speechData.indexPath else { fatalError() }
		tableController?.setHighlight(indexPath: indexPath, highlight: highlight)
	}
}
