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
class CalendarView: UIView {
	// MARK: - Init

	/// A weak reference to the logic for informing about any user actions in this view.
	private weak var logic: CalendarLogicInterface?

	/**
	 Initializes this view.

	 - parameter logic: The logic to inform about any user actions. Will not be retained.
	 */
	init(logic: CalendarLogicInterface) {
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
		accessibilityIdentifier = Const.CalendarTests.ViewName.mainView

		// Create view hierarchy.
		addSubview(navigationView)
		addSubview(weekNamesView)
		addSubview(tableView)

		// Position the navigation view at the top.
		navigationView.leadingAnchor == leadingAnchor
		navigationView.trailingAnchor == trailingAnchor
		navigationView.topAnchor == topAnchor

		// The week names view sticks at the bottom of the navigation view.
		weekNamesView.leadingAnchor == leadingAnchor
		weekNamesView.trailingAnchor == trailingAnchor
		weekNamesView.topAnchor == navigationView.bottomAnchor

		// The table view fills up the rest of the view.
		tableView.leadingAnchor == leadingAnchor
		tableView.trailingAnchor == trailingAnchor
		tableView.bottomAnchor == bottomAnchor
		// Make the constraint break when the table view should expand full screen.
		tableView.topAnchor == weekNamesView.bottomAnchor ~ .high

		// Set default styles.
		backgroundColor = Const.Color.darkMain
		tableFullscreen = { tableFullscreen }()

		// Register for callback actions.
		navigationView.onLeftButtonPressed.setDelegate(to: self, with: { strongSelf, _ in
			strongSelf.logic?.backButtonPressed()
		})
		navigationView.onRightButtonPressed.setDelegate(to: self, with: { strongSelf, _ in
			strongSelf.logic?.addButtonPressed()
		})
	}

	// MARK: - Subviews

	/// The navigation view at the top of the view.
	private let navigationView: NavigationView = {
		let view = NavigationView()
		view.title = R.string.calendar.title()
		view.leftButtonType = .back
		view.leftButtonVisible = true
		view.rightButtonType = .add
		view.rightButtonVisible = true
		return view
	}()

	private let weekNamesView: WeekNamesView = {
		let view = WeekNamesView()
		return view
	}()

	/// The table view filling the view under the navigation view.
	let tableView: UITableView = {
		let tableView = BaseTableView(frame: .max, style: .plain)
		tableView.accessibilityIdentifier = Const.NewAppointmentTests.ViewName.tableView
		return tableView
	}()

	/// The constraints used when the `tableFullscreen` property is `true`.
	private lazy var tableFullscreenConstraints: [NSLayoutConstraint] = {
		Anchorage.batch(active: false) {
			tableView.topAnchor == topAnchor
		}
	}()

	// MARK: - Properties

	/// Set to `false` (default) to show the navigation bar and the week names as part of the view at the top.
	/// Set to `true` to hide them and make the table view full screen.
	var tableFullscreen = false {
		didSet {
			navigationView.isHidden = tableFullscreen
			weekNamesView.isHidden = tableFullscreen

			// Apply constraints.
			if tableFullscreen {
				NSLayoutConstraint.activate(tableFullscreenConstraints)
			} else {
				NSLayoutConstraint.deactivate(tableFullscreenConstraints)
			}
		}
	}

	// MARK: - Interface Builder

	@IBInspectable private lazy var ibTableFullscreen: Bool = tableFullscreen

	override func prepareForInterfaceBuilder() {
		// For crashing reports look at '~/Library/Logs/DiagnosticReports/'.
		super.prepareForInterfaceBuilder()

		tableFullscreen = ibTableFullscreen
	}
}
