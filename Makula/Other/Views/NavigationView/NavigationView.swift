import Anchorage
import UIKit

/**
 The view at the top of most views which functions as a navigation bar replacement.
 Shows the controller's title and provides a back button.
 */
@IBDesignable
class NavigationView: UIView {
	// MARK: - Init

	init() {
		super.init(frame: .max)
		configureView()
	}

	@available(*, unavailable)
	override init(frame: CGRect) {
		// Needed to render in InterfaceBuilder.
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
		translatesAutoresizingMaskIntoConstraints = false
		accessibilityIdentifier = Const.NavigationViewTests.ViewName.navigationView

		// Create view hierarchy.
		addSubview(titleLabel)
		addSubview(leftButton)
		addSubview(rightButton)
		addSubview(separatorView)

		// Min height for this view, but let it break when rotating.
		heightAnchor >= 50 ~ .required - 1

		// Make the view height fit the title label.
		titleLabel.topAnchor == layoutMarginsGuide.topAnchor
		// Let the bottom constraint break during rotations.
		titleLabel.bottomAnchor == layoutMarginsGuide.bottomAnchor ~ .required - 10
		// Center the title label horizontally.
		titleLabel.centerXAnchor == layoutMarginsGuide.centerXAnchor
		titleLabel.leftAnchor >= leftButton.rightAnchor + Const.Size.defaultGap
		titleLabel.rightAnchor <= rightButton.leftAnchor - Const.Size.defaultGap
		// Let the title label stop expanding when there is no room.
		titleLabel.horizontalCompressionResistance = .high - 1

		// The left button is left of the title.
		leftButton.centerYAnchor == titleLabel.centerYAnchor
		leftButton.leftAnchor == layoutMarginsGuide.leftAnchor
		// Expand the left button's touch area to the whole left half of the view.
		leftButton.touchArea.leftAnchor == leftAnchor
		leftButton.touchArea.topAnchor == topAnchor
		leftButton.touchArea.bottomAnchor == bottomAnchor
		leftButton.touchArea.widthAnchor == widthAnchor * 0.5

		// The right button is right of the title.
		rightButton.centerYAnchor == titleLabel.centerYAnchor
		rightButton.rightAnchor == layoutMarginsGuide.rightAnchor
		// Expand the right button's touch area to the whole right half of the view.
		rightButton.touchArea.rightAnchor == rightAnchor
		rightButton.touchArea.topAnchor == topAnchor
		rightButton.touchArea.bottomAnchor == bottomAnchor
		rightButton.touchArea.widthAnchor == widthAnchor * 0.5

		// Add the separator at the bottom.
		separatorView.leadingAnchor == layoutMarginsGuide.leadingAnchor
		separatorView.trailingAnchor == layoutMarginsGuide.trailingAnchor
		separatorView.bottomAnchor == bottomAnchor
		// A heigh constraint which can break for the even thicker line constraint when in large mode.
		separatorView.heightAnchor == Const.Size.separatorThicknessNormal ~ .high

		// Apply margins.
		if #available(iOS 11.0, *) {
			directionalLayoutMargins = Const.NavigationView.Margin.content.directional
		} else {
			layoutMargins = Const.NavigationView.Margin.content.withStatusBar
		}

		// Set default styles.
		backgroundColor = Const.Color.darkMain
		titleColor = { titleColor }()
		largeStyle = { largeStyle }()
		separatorVisible = { separatorVisible }()
		leftButtonVisible = { leftButtonVisible }()
		rightButtonVisible = { rightButtonVisible }()
	}

	// MARK: - Subviews

	/// The title centered in the header.
	private let titleLabel: UILabel = {
		let label = UILabel(frame: .max)
		label.accessibilityIdentifier = Const.NavigationViewTests.ViewName.titleLabel
		label.textAlignment = .center
		return label
	}()

	/// The button at the left.
	private let leftButton: ImageButton = {
		let button = ImageButton(type: .back)
		button.accessibilityIdentifier = Const.NavigationViewTests.ViewName.leftButton
		return button
	}()

	/// The button at the right.
	private let rightButton: ImageButton = {
		let button = ImageButton(type: .speaker)
		button.accessibilityIdentifier = Const.NavigationViewTests.ViewName.rightButton
		return button
	}()

	/// The separator line at the bottom of the view.
	private let separatorView: UIView = {
		let view = UIView(frame: .max)
		view.accessibilityIdentifier = Const.NavigationViewTests.ViewName.separatorView
		return view
	}()

	/// The constraints used when the `largeStyle` property is `true`.
	private lazy var scaledConstraints: [NSLayoutConstraint] = {
		Anchorage.batch(active: false) {
			separatorView.heightAnchor == Const.Size.separatorThicknessLarge
		}
	}()

	// MARK: - Properties

	/// The text of the title label.
	var title: String {
		get { return titleLabel.attributedText?.string ?? String.empty }
		set { titleLabel.attributedText = newValue.styled(with: Const.StringStyle.base) }
	}

	/// The text color of the title label.
	var titleColor = Const.Color.white {
		didSet {
			titleLabel.textColor = titleColor
			separatorView.backgroundColor = titleColor
		}
	}

	/// Whether the view uses a large font for labels and a scaled version for the icons or not. Defaults to `false`.
	var largeStyle = false {
		didSet {
			// Update the title's font to use the new style.
			titleLabel.font = largeStyle ? Const.Font.titleLarge : Const.Font.titleDefault

			// Update sub-button styles.
			leftButton.largeStyle = largeStyle
			rightButton.largeStyle = largeStyle

			// Apply constraints.
			if largeStyle {
				NSLayoutConstraint.activate(scaledConstraints)
			} else {
				NSLayoutConstraint.deactivate(scaledConstraints)
			}
		}
	}

	/// The visibility state of the separator line. Set to `false` to hide it, `true` (default) to show it.
	var separatorVisible = true {
		didSet {
			separatorView.isHidden = !separatorVisible
		}
	}

	/// The visibility state of the left button. Set to `false` (default) to hide it, `true` to show it.
	var leftButtonVisible = false {
		didSet {
			leftButton.isHidden = !leftButtonVisible
		}
	}

	/// The type of button the left button is.
	var leftButtonType: ImageButton.ImageButtonType {
		get {
			return leftButton.type
		}
		set {
			leftButton.type = newValue
		}
	}

	/// The visibility state of the right button. Set to `false` (default) to hide it, `true` to show it.
	var rightButtonVisible = false {
		didSet {
			rightButton.isHidden = !rightButtonVisible
		}
	}

	/// The type of button the right button is.
	var rightButtonType: ImageButton.ImageButtonType {
		get {
			return rightButton.type
		}
		set {
			rightButton.type = newValue
		}
	}

	/// The delegate caller who informs about a left button press.
	private(set) lazy var onLeftButtonPressed: ControlCallback<NavigationView> = {
		ControlCallback(for: leftButton, event: .touchUpInside) { [unowned self] in
			self
		}
	}()

	/// The delegate caller who informs about a right button press.
	private(set) lazy var onRightButtonPressed: ControlCallback<NavigationView> = {
		ControlCallback(for: rightButton, event: .touchUpInside) { [unowned self] in
			self
		}
	}()

	// MARK: - Interface Builder

	@IBInspectable private lazy var ibBgColor: UIColor = Const.Color.darkMain
	@IBInspectable private lazy var ibTitle: String = "Title"
	@IBInspectable private lazy var ibLargeStyle: Bool = largeStyle
	@IBInspectable private lazy var ibSepVisible: Bool = separatorVisible
	@IBInspectable private lazy var ibLeftVisible: Bool = leftButtonVisible
	@IBInspectable private lazy var ibLeftType: Int = leftButtonType.rawValue
	@IBInspectable private lazy var ibRightVisible: Bool = rightButtonVisible
	@IBInspectable private lazy var ibRightType: Int = rightButtonType.rawValue
	@IBInspectable private lazy var ibTitleColor: UIColor = titleColor

	override func prepareForInterfaceBuilder() {
		// For crashing reports look at '~/Library/Logs/DiagnosticReports/'.
		super.prepareForInterfaceBuilder()
		translatesAutoresizingMaskIntoConstraints = true

		backgroundColor = ibBgColor
		title = ibTitle
		largeStyle = ibLargeStyle
		separatorVisible = ibSepVisible
		leftButtonVisible = ibLeftVisible
		leftButtonType = ImageButton.ImageButtonType(rawValue: ibLeftType) ?? .back
		rightButtonVisible = ibRightVisible
		rightButtonType = ImageButton.ImageButtonType(rawValue: ibRightType) ?? .back
		titleColor = ibTitleColor
	}
}
