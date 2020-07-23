import Anchorage
import UIKit

/**
 The split cell's content view showing a left and a right title label separated by a vertical line.
 */
@IBDesignable
class SplitCellView: UIView {
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

		// Create view hierarchy.
		addSubview(leftTitleButton)
		addSubview(rightTitleButton)
		addSubview(separatorView)

		// The left title takse the left half.
		leftTitleButton.leadingAnchor == layoutMarginsGuide.leadingAnchor
		leftTitleButton.topAnchor == layoutMarginsGuide.topAnchor
		leftTitleButton.bottomAnchor == layoutMarginsGuide.bottomAnchor
		leftTitleButton.heightAnchor >= Const.Size.cellDefaultLabelMinHeight

		// The right title takse the right half.
		rightTitleButton.trailingAnchor == layoutMarginsGuide.trailingAnchor
		rightTitleButton.topAnchor == layoutMarginsGuide.topAnchor
		rightTitleButton.bottomAnchor == layoutMarginsGuide.bottomAnchor
		rightTitleButton.heightAnchor >= Const.Size.cellDefaultLabelMinHeight

		// Connect both buttons.
		leftTitleButton.trailingAnchor == rightTitleButton.leadingAnchor - 2 * Const.SplitCellView.Size.middleGap
		leftTitleButton.widthAnchor == rightTitleButton.widthAnchor

		// Add the separator to the bottom.
		separatorView.leadingAnchor == layoutMarginsGuide.leadingAnchor
		separatorView.trailingAnchor == layoutMarginsGuide.trailingAnchor
		separatorView.bottomAnchor == bottomAnchor
		// A heigh constraint which can break for the even thicker line constraint when in large mode.
		separatorView.heightAnchor == Const.Size.separatorThicknessNormal ~ .high

		// Apply margins.
		if #available(iOS 11.0, *) {
			directionalLayoutMargins = Const.Margin.cell.directional
		} else {
			layoutMargins = Const.Margin.cell
		}

		// Set default styles.
		backColor = { backColor }()
		separatorColor = { separatorColor }()
		largeStyle = { largeStyle }()
		isEnabled = true
	}

	// MARK: - Subviews

	/// The left title button.
	private let leftTitleButton: TextButton = {
		let button = TextButton()
		button.accessibilityIdentifier = Const.SplitCellViewTests.ViewName.leftTitle
		button.defaultColor = Const.Color.magenta
		button.highlightColor = Const.Color.white
		button.titleTextAlignment = .left
		button.commonMargin = false
		return button
	}()

	/// The right title button.
	private let rightTitleButton: TextButton = {
		let button = TextButton()
		button.accessibilityIdentifier = Const.SplitCellViewTests.ViewName.rightTitle
		button.defaultColor = Const.Color.lightMain
		button.highlightColor = Const.Color.white
		button.titleTextAlignment = .right
		return button
	}()

	/// The separator at the bottom.
	private let separatorView: UIView = {
		let view = UIView(frame: .max)
		view.accessibilityIdentifier = Const.SplitCellViewTests.ViewName.horizontalSeparator
		return view
	}()

	/// The constraints used when the `largeStyle` property is `true`.
	private lazy var scaledConstraints: [NSLayoutConstraint] = {
		Anchorage.batch(active: false) {
			separatorView.heightAnchor == Const.Size.separatorThicknessLarge
		}
	}()

	// MARK: - Properties

	/// The title string for the left side.
	var leftTitle: String {
		get { return leftTitleButton.title }
		set { leftTitleButton.title = newValue }
	}

	/// The title string for the right side.
	var rightTitle: String {
		get { return rightTitleButton.title }
		set { rightTitleButton.title = newValue }
	}

	/// Whether the left title button is selected.
	var leftSelected: Bool {
		get { return leftTitleButton.isSelected }
		set { leftTitleButton.isSelected = newValue }
	}

	/// Whether the right title button is selected.
	var rightSelected: Bool {
		get { return rightTitleButton.isSelected }
		set { rightTitleButton.isSelected = newValue }
	}

	/// Whether the view uses a large style for labels and sub-views. Defaults to `false`.
	var largeStyle = false {
		didSet {
			// Apply style to subviews.
			leftTitleButton.largeStyle = largeStyle
			rightTitleButton.largeStyle = largeStyle

			// Apply constraints.
			if largeStyle {
				NSLayoutConstraint.activate(scaledConstraints)
			} else {
				NSLayoutConstraint.deactivate(scaledConstraints)
			}
		}
	}

	/// Wheter the button is enabled and interaction is possible or not.
	var isEnabled: Bool {
		get { return leftTitleButton.isEnabled && rightTitleButton.isEnabled }
		set {
			leftTitleButton.isEnabled = newValue
			rightTitleButton.isEnabled = newValue
		}
	}

	/// The default background color for the view.
	var backColor = Const.Color.darkMain {
		didSet {
			backgroundColor = backColor
		}
	}

	/// The color for the separators.
	var separatorColor = Const.Color.lightMain {
		didSet {
			separatorView.backgroundColor = separatorColor
		}
	}

	/// The delegate caller who informs about the left title button press.
	private(set) lazy var onLeftTitleButtonPressed: ControlCallback<SplitCellView> = {
		ControlCallback(for: leftTitleButton, event: .touchUpInside) { [unowned self] in
			self
		}
	}()

	/// The delegate caller who informs about the right title button press.
	private(set) lazy var onRightTitleButtonPressed: ControlCallback<SplitCellView> = {
		ControlCallback(for: rightTitleButton, event: .touchUpInside) { [unowned self] in
			self
		}
	}()

	// MARK: - Interface Builder

	@IBInspectable private lazy var ibLeftTitle: String = "Left"
	@IBInspectable private lazy var ibRightTitle: String = "Right"
	@IBInspectable private lazy var ibLeftSelected: Bool = leftSelected
	@IBInspectable private lazy var ibRightSelected: Bool = rightSelected
	@IBInspectable private lazy var ibLargeStyle: Bool = largeStyle
	@IBInspectable private lazy var ibBackColor: UIColor = backColor
	@IBInspectable private lazy var ibSepColor: UIColor = separatorColor

	override func prepareForInterfaceBuilder() {
		// For crashing reports look at '~/Library/Logs/DiagnosticReports/'.
		super.prepareForInterfaceBuilder()

		translatesAutoresizingMaskIntoConstraints = true
		backgroundColor = Const.Color.darkMain

		leftTitle = ibLeftTitle
		rightTitle = ibRightTitle
		leftSelected = ibLeftSelected
		rightSelected = ibRightSelected
		largeStyle = ibLargeStyle
		separatorColor = ibSepColor
		backColor = ibBackColor
	}
}
