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
class MenuView: UIView {
	// MARK: - Init

	/// A weak reference to the logic for informing about any user actions in this view.
	private weak var logic: MenuLogicInterface?

	/**
	 Initializes this view.

	 - parameter logic: The logic to inform about any user actions. Will not be retained.
	 */
	init(logic: MenuLogicInterface) {
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
		accessibilityIdentifier = Const.MenuTests.ViewName.mainView

		// Create view hierarchy.
		addSubview(navigationView)
		addSubview(tableView)

		// Position the navigation view at the top.
		navigationView.leadingAnchor == leadingAnchor
		navigationView.trailingAnchor == trailingAnchor
		navigationView.topAnchor == topAnchor

		// The table view fills up the rest of the view under the navigation view.
		tableView.leadingAnchor == leadingAnchor
		tableView.trailingAnchor == trailingAnchor
		tableView.topAnchor == navigationView.bottomAnchor
		tableView.bottomAnchor == bottomAnchor

		// Set default styles.
		backgroundColor = Const.Color.darkMain
		navigationViewHidden = { navigationViewHidden }()

		// Register for callback actions.
		navigationView.onLeftButtonPressed.setDelegate(to: self, with: { strongSelf, _ in
			strongSelf.logic?.backButtonPressed()
		})
		navigationView.onRightButtonPressed.setDelegate(to: self, with: { strongSelf, _ in
			strongSelf.logic?.speakButtonPressed()
		})
	}

	// MARK: - Subviews

	/// The table view filling the view under the navigation view.
	let tableView: UITableView = {
		let tableView = BaseTableView(frame: .max, style: .plain)
		tableView.accessibilityIdentifier = Const.MenuTests.ViewName.tableView
		return tableView
	}()

	/// The navigation view at the top of the view.
	private let navigationView: NavigationView = {
		let view = NavigationView()
		view.leftButtonType = .back
		view.rightButtonVisible = true
		view.rightButtonType = .speaker
		return view
	}()

	/// The constraint to activate for hiding the navigation view.
	private lazy var navigationViewHeightConstraint: NSLayoutConstraint = {
		navigationView.heightAnchor == 0
	}()

	// MARK: - Properties

	/// Set to `false` (default) to show the navigation bar as part of the view at the top.
	/// Set to `true` to hide it and make the table view full screen.
	var navigationViewHidden = false {
		didSet {
			navigationView.isHidden = navigationViewHidden
			navigationViewHeightConstraint.isActive = navigationViewHidden
		}
	}

	/// The title of the navigation view.
	var navigationViewTitle: String {
		get { return navigationView.title }
		set { navigationView.title = newValue }
	}

	/// The visibility of the back button.
	var backButtonVisible: Bool {
		get { return navigationView.leftButtonVisible }
		set { navigationView.leftButtonVisible = newValue }
	}

	// MARK: - Interface Builder

	@IBInspectable private lazy var ibNavHidden: Bool = navigationViewHidden
	@IBInspectable private lazy var ibNavTitle: String = "Title"
	@IBInspectable private lazy var ibBackVisible: Bool = backButtonVisible

	override func prepareForInterfaceBuilder() {
		// For crashing reports look at '~/Library/Logs/DiagnosticReports/'.
		super.prepareForInterfaceBuilder()

		navigationViewHidden = ibNavHidden
		navigationViewTitle = ibNavTitle
		backButtonVisible = ibBackVisible
	}
}
