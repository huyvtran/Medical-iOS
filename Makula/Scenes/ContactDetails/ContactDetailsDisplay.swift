import UIKit

/**
 The view controller which represents the display.

 Its purpose is to hold references to the logic and any views in the scene.
 It is responsible for displaying data provided by the logic by manipulating the view.
 The view controller does NOT manage the routing to other scenes, this is the purpose of the router which is called by the logic.
 The view controller is NOT responsible for any logic beyond formatting the output.
 */
class ContactDetailsDisplay: BaseViewController {
	// MARK: - Dependencies

	/// The reference to the logic.
	private var logic: ContactDetailsLogicInterface?

	/// The factory method which creates the logic for this display during setup.
	var createLogic: (ContactDetailsDisplayInterface, UIViewController) -> ContactDetailsLogicInterface = { display, viewController in
		ContactDetailsLogic(display: display, router: ContactDetailsRouter(viewController: viewController))
	}

	/// The delegate controller for the table view.
	private var tableController: ContactDetailsTableControllerInterface?

	/// The factory method which creates the table controller when the view gets loaded.
	var createTableController: (UITableView, ContactDetailsLogicInterface) -> ContactDetailsTableControllerInterface = { tableview, logic in
		ContactDetailsTableController(tableView: tableview, logic: logic)
	}

	/// The mail controller for the MessageUI.
	var mailController = MailController()

	// MARK: - Setup

	/**
	 Sets up the instance with a new model.
	 Creates the logic if needed.

	 Has to be called before presenting the view controller.

	 - parameter model: The parameters for setup.
	 */
	func setup(model: ContactDetailsRouterModel.Setup) {
		// Set up Logic.
		if logic == nil {
			logic = createLogic(self, self)
		}
		logic?.setModel(model)
	}

	// MARK: - View

	/// The root view of this controller. Only defined after the controller's view has been loaded.
	private var rootView: ContactDetailsView! { return view as? ContactDetailsView }

	override func loadView() {
		guard let logic = logic else { fatalError("Logic instance expected") }
		view = ContactDetailsView(logic: logic)
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

// MARK: - ContactDetailsDisplayInterface

extension ContactDetailsDisplay: ContactDetailsDisplayInterface {
	func updateDisplay(model: ContactDetailsDisplayModel.UpdateDisplay) {
		// Update the view.
		rootView.navigationViewHidden = model.largeStyle
		// Update table view.
		tableController?.setData(model: model)
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

	func showError(title: String, message: String) {
		let alert = UIAlertController(
			title: title,
			message: message,
			preferredStyle: .alert
		)
		let confirmAction = UIAlertAction(
			title: R.string.global.defaultErrorConfirmButton(),
			style: .default,
			handler: nil
		)
		alert.addAction(confirmAction)
		present(alert, animated: true)
	}

	func askForPhoneCall(phoneNumber: String) {
		let alert = UIAlertController(
			title: R.string.contactDetails.phoneCallAlertTitle(),
			message: R.string.contactDetails.phoneCallAlertMessage(phoneNumber),
			preferredStyle: .alert
		)
		let confirmAction = UIAlertAction(
			title: R.string.contactDetails.phoneCallConfirmButton(),
			style: .default
		) { [weak self] _ in
			self?.logic?.initiatePhoneCall(phoneNumber: phoneNumber)
		}
		alert.addAction(confirmAction)
		let cancelAction = UIAlertAction(
			title: R.string.contactDetails.phoneCallCancelButton(),
			style: .cancel,
			handler: nil
		)
		alert.addAction(cancelAction)
		present(alert, animated: true)
	}

	func showMail(emailAddress: String) {
		guard let mail = mailController.createMail(emailAddress: emailAddress) else {
			// Emails can't be send, inform user.
			showError(title: R.string.contactDetails.emailFailureTitle(), message: R.string.contactDetails.emailFailureMessage())
			return
		}
		present(mail, animated: true)
	}

	func scrollToTop() {
		tableController?.scrollToTop()
	}

	func setHighlightCell(for speechData: SpeechData, highlight: Bool) {
		guard let indexPath = speechData.indexPath else { fatalError() }
		tableController?.setHighlight(indexPath: indexPath, highlight: highlight)
	}
}
