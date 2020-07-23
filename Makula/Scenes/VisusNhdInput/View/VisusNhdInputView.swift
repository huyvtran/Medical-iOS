import Anchorage
import UIKit

/**
 The scene controller's root view.

 This will be created in the controller's `loadView` method and creates the view with code instead of using Xibs and Storyboards.
 The root view is responsible for creating the view hierarchy and holds all subview references so that the display can access them.
 The view also forwards any user actions from controls to the logic.
 And the view might also provide additional code for displaying certain view states,
 but the view does NOT perform any logic nor formatting.
 */
@IBDesignable
class VisusNhdInputView: UIView {
	// MARK: - Init

	/// A weak reference to the logic for informing about any user actions in this view.
	private weak var logic: VisusNhdInputLogicInterface?

	/**
	 Initializes this view.

	 - parameter logic: The logic to inform about any user actions. Will not be retained.
	 */
	init(logic: VisusNhdInputLogicInterface) {
		self.logic = logic
		super.init(frame: .max)
		configureView()
	}

	@available(*, unavailable)
	override init(frame: CGRect) {
		// Needed for InterfaceBuilder
		super.init(frame: frame)
		configureView()
	}

	@available(*, unavailable, message: "Instantiating via Xib & Storyboard is prohibited.")
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	/**
	 Builds up the view hierarchy and applies the layout.
	 */
	private func configureView() {
		accessibilityIdentifier = Const.VisusNhdInputTests.ViewName.mainView

		// Create view hierarchy.
		addSubview(navigationView)
		addSubview(tableView)
		addSubview(confirmButton)

		// Position the navigation view at the top.
		navigationView.leadingAnchor == leadingAnchor
		navigationView.trailingAnchor == trailingAnchor
		navigationView.topAnchor == topAnchor

		// Place the confirm button at the bottom.
		confirmButton.leadingAnchor == leadingAnchor
		confirmButton.trailingAnchor == trailingAnchor
		confirmButton.bottomAnchor == bottomAnchor

		// The table view fills up the rest of the view.
		tableView.leadingAnchor == leadingAnchor
		tableView.trailingAnchor == trailingAnchor
		tableView.topAnchor == navigationView.bottomAnchor
		tableView.bottomAnchor == confirmButton.topAnchor

		// Set default styles.
		backgroundColor = Const.Color.darkMain
		navigationViewHidden = { navigationViewHidden }()
		confirmButtonEnabled = { confirmButtonEnabled }()

		// Register for callback actions.
		navigationView.onLeftButtonPressed.setDelegate(to: self, with: { strongSelf, _ in
			strongSelf.logic?.backButtonPressed()
		})
		navigationView.onRightButtonPressed.setDelegate(to: self, with: { strongSelf, _ in
			strongSelf.logic?.infoButtonPressed()
		})
		onConfirmButtonPressed.setDelegate(to: self, with: { strongSelf, _ in
			strongSelf.logic?.confirmButtonPressed()
		})
	}

	// MARK: - Subviews

	/// The navigation view at the top of the view.
	private let navigationView: NavigationView = {
		let view = NavigationView()
		view.leftButtonType = .back
		view.leftButtonVisible = true
		view.rightButtonType = .navInfo
		view.rightButtonVisible = true
		return view
	}()

	/// The constraint to activate for hiding the navigation view.
	private lazy var navigationViewHeightConstraint: NSLayoutConstraint = {
		navigationView.heightAnchor == 0
	}()

	/// The confirm button at the bottom.
	private let confirmButton: ConfirmButton = {
		let button = ConfirmButton()
		button.accessibilityIdentifier = Const.VisusNhdInputTests.ViewName.confirmButton
		button.titleText = R.string.visusNhdInput.confirmButtonTitle()
		button.arrowVisible = false
		return button
	}()

	// MARK: - Properties

	/// The navigation view's title (when not part of the table view).
	var title: String {
		set {
			navigationView.title = newValue
		}
		get {
			return navigationView.title
		}
	}

	/// The table view filling the view under the navigation view.
	let tableView: UITableView = {
		let tableView = BaseTableView(frame: .max, style: .plain)
		tableView.accessibilityIdentifier = Const.VisusNhdInputTests.ViewName.tableView
		return tableView
	}()

	/// Set to `false` (default) to show the navigation bar as part of the view at the top.
	/// Set to `true` to hide it and make the table view full screen.
	var navigationViewHidden = false {
		didSet {
			navigationView.isHidden = navigationViewHidden
			navigationViewHeightConstraint.isActive = navigationViewHidden
		}
	}

	/// Whether the view uses a large style for sub-views. Defaults to `false`.
	var largeStyle = false {
		didSet {
			confirmButton.largeStyle = largeStyle
		}
	}

	/// Whether the confirm button is enabled or not. Defaults to `false`.
	var confirmButtonEnabled = false {
		didSet {
			confirmButton.isEnabled = confirmButtonEnabled
		}
	}

	/// The delegate caller who informs about a confirm button press.
	private(set) lazy var onConfirmButtonPressed: ControlCallback<VisusNhdInputView> = {
		ControlCallback(for: confirmButton, event: .touchUpInside) { [unowned self] in
			self
		}
	}()

	// MARK: - Interface Builder

	@IBInspectable private lazy var ibNavigationViewHidden: Bool = navigationViewHidden
	@IBInspectable private lazy var ibTitle: String = "Title"
	@IBInspectable private lazy var ibConfirmButtonEnabled: Bool = confirmButtonEnabled
	@IBInspectable private lazy var ibLargeStyle: Bool = largeStyle

	override func prepareForInterfaceBuilder() {
		// For crashing reports look at '~/Library/Logs/DiagnosticReports/'.
		super.prepareForInterfaceBuilder()

		navigationViewHidden = ibNavigationViewHidden
		title = ibTitle
		confirmButtonEnabled = ibConfirmButtonEnabled
		largeStyle = ibLargeStyle
	}
}
