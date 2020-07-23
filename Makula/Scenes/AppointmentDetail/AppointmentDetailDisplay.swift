import UIKit

/**
 The view controller which represents the display.

 Its purpose is to hold references to the logic and any views in the scene.
 It is responsible for displaying data provided by the logic by manipulating the view.
 The view controller does NOT manage the routing to other scenes, this is the purpose of the router which is called by the logic.
 The view controller is NOT responsible for any logic beyond formatting the output.
 */
class AppointmentDetailDisplay: BaseViewController {
	// MARK: - Dependencies

	/// The reference to the logic.
	private var logic: AppointmentDetailLogicInterface?

	/// The factory method which creates the logic for this display during setup.
	var createLogic: (AppointmentDetailDisplayInterface, UIViewController) -> AppointmentDetailLogicInterface = { display, viewController in
		AppointmentDetailLogic(display: display, router: AppointmentDetailRouter(viewController: viewController))
	}

	/// The delegate controller for the table view.
	private var tableController: AppointmentDetailTableControllerInterface?

	/// The factory method which creates the table controller when the view gets loaded.
	var createTableController: (UITableView, AppointmentDetailLogicInterface) -> AppointmentDetailTableControllerInterface = { tableview, logic in
		AppointmentDetailTableController(tableView: tableview, logic: logic)
	}

	// MARK: - Setup

	/**
	 Sets up the instance with a new model.
	 Creates the logic if needed.

	 Has to be called before presenting the view controller.

	 - parameter model: The parameters for setup.
	 */
	func setup(model: AppointmentDetailRouterModel.Setup) {
		// Set up Logic.
		if logic == nil {
			logic = createLogic(self, self)
		}
		logic?.setModel(model)
	}

	// MARK: - View

	/// The root view of this controller. Only defined after the controller's view has been loaded.
	private var rootView: AppointmentDetailView! { return view as? AppointmentDetailView }

	override func loadView() {
		guard let logic = logic else { fatalError("Logic instance expected") }
		view = AppointmentDetailView(logic: logic)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		guard let logic = logic else { fatalError("Logic instance expected") }

		// Create table controller.
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

// MARK: - AppointmentDetailDisplayInterface

extension AppointmentDetailDisplay: AppointmentDetailDisplayInterface {
	func updateDisplay(model: AppointmentDetailDisplayModel.UpdateDisplay) {
		// Update the navigation view.
		rootView.navigationViewHidden = model.largeStyle
		rootView.navigationViewTitle = model.title
		rootView.navigationViewTitleColor = model.titleColor

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

	func confirmDeletion() {
		let alert = UIAlertController(
			title: R.string.appointmentDetail.deleteAlertTitle(),
			message: R.string.appointmentDetail.deleteAlertMessage(),
			preferredStyle: .alert
		)
		let confirmAction = UIAlertAction(title: R.string.appointmentDetail.deleteAlertConfirm(), style: .destructive) { [weak self] _ in
			self?.logic?.deleteConfirmed()
		}
		alert.addAction(confirmAction)
		let cancelAction = UIAlertAction(title: R.string.appointmentDetail.deleteAlertCancel(), style: .default) { _ in
		}
		alert.addAction(cancelAction)
		present(alert, animated: true)
	}
}
