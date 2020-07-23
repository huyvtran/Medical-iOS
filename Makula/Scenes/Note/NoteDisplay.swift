import UIKit

/**
 The view controller which represents the display.

 Its purpose is to hold references to the logic and any views in the scene.
 It is responsible for displaying data provided by the logic by manipulating the view.
 The view controller does NOT manage the routing to other scenes, this is the purpose of the router which is called by the logic.
 The view controller is NOT responsible for any logic beyond formatting the output.
 */
class NoteDisplay: BaseViewController {
	// MARK: - Dependencies

	/// The reference to the logic.
	private var logic: NoteLogicInterface?

	/// The display model.
	private var displayModel: NoteDisplayModel.UpdateDisplay?

	/// The factory method which creates the logic for this display during setup.
	var createLogic: (NoteDisplayInterface, UIViewController) -> NoteLogicInterface = { display, viewController in
		NoteLogic(display: display, router: NoteRouter(viewController: viewController))
	}

	/// The delegate controller for the text view.
	private var textViewController: NoteTextViewController?

	/// The factory method which creates the text view controller when the view gets loaded.
	var createTextViewController: (NoteView, NoteLogicInterface) -> NoteTextViewController = { view, logic in
		NoteTextViewController(mainView: view, logic: logic)
	}

	/// The keyboard controller which manages the keyboard notification.
	var keyboardController = KeyboardController()

	// MARK: - Setup

	/**
	 Sets up the instance with a new model.
	 Creates the logic if needed.

	 Has to be called before presenting the view controller.

	 - parameter model: The parameters for setup.
	 */
	func setup(model: NoteRouterModel.Setup) {
		// Set up Logic.
		if logic == nil {
			logic = createLogic(self, self)
		}
		logic?.setModel(model)
	}

	// MARK: - View

	/// The root view of this controller. Only defined after the controller's view has been loaded.
	private var rootView: NoteView! { return view as? NoteView }

	override func loadView() {
		guard let logic = logic else { fatalError("Logic instance expected") }
		view = NoteView(logic: logic)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		guard let logic = logic else { fatalError("Logic instance expected") }

		// Register for keyboard notifications.
		keyboardController.delegate = self

		// Create text view controller.
		textViewController = createTextViewController(rootView, logic)
		rootView.textViewDelegate = textViewController
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		// Request initial display data.
		logic?.requestDisplayData()
		rootView.bringContentToTop()
	}

	override func viewDidDisappear(_ animated: Bool) {
		// Updates the existing note model.
		let content = rootView.isContentEmpty ? String.empty : rootView.contentText
		logic?.updateNoteModel(content: content)

		super.viewWillDisappear(animated)
	}

	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		coordinator.animate(alongsideTransition: { _ in
		}, completion: { _ in
			self.logic?.requestDisplayData()
		})
		super.viewWillTransition(to: size, with: coordinator)
	}
}

// MARK: - NoteDisplayInterface

extension NoteDisplay: NoteDisplayInterface {
	func updateDisplay(model: NoteDisplayModel.UpdateDisplay) {
		displayModel = model
		// Update the view.
		rootView.largeStyle = model.largeStyle
		rootView.navigationViewHidden = model.largeStyle
		rootView.bringContentToTop()

		if let noteModel = model.noteModel, let content = noteModel.content, content.count > 0 {
			rootView.contentText = content
			rootView.isContentEmpty = false

			// Set speech data.
			let speechData = SpeechData(text: content, indexPath: nil)
			logic?.setSpeechData(data: [speechData])
		}
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
}

// MARK: - KeyboardControllerDelegate

extension NoteDisplay: KeyboardControllerDelegate {
	func keyboardShows(keyboardSize: CGSize) {
		rootView.contentViewBottomConstraint?.constant = -keyboardSize.height
	}

	func keyboardShown() {}

	func keyboardHides() {
		rootView.contentViewBottomConstraint?.constant = 0
	}

	func keyboardHidden() {}
}
