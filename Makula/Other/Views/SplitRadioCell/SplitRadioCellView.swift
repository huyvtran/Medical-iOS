import Anchorage
import UIKit

/**
 The split radio cell's content view showing a label centered, a left and a right radio button.
 */
@IBDesignable
class SplitRadioCellView: UIView {
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
		addSubview(titleLabel)
		addSubview(leftRadioButton)
		addSubview(rightRadioButton)
		addSubview(separatorView)

		// The left radio button goes to the left.
		leftRadioButton.leadingAnchor == layoutMarginsGuide.leadingAnchor
		leftRadioButton.centerYAnchor == titleLabel.centerYAnchor

		// The right radio button goes to the right.
		rightRadioButton.trailingAnchor == layoutMarginsGuide.trailingAnchor
		rightRadioButton.centerYAnchor == titleLabel.centerYAnchor

		// The left button's touch area takse the left half.
		leftRadioButton.touchArea.leadingAnchor == layoutMarginsGuide.leadingAnchor
		leftRadioButton.touchArea.topAnchor == layoutMarginsGuide.topAnchor
		leftRadioButton.touchArea.bottomAnchor == layoutMarginsGuide.bottomAnchor

		// The right button's touch area takse the right half.
		rightRadioButton.touchArea.trailingAnchor == layoutMarginsGuide.trailingAnchor
		rightRadioButton.touchArea.topAnchor == layoutMarginsGuide.topAnchor
		rightRadioButton.touchArea.bottomAnchor == layoutMarginsGuide.bottomAnchor

		// Connect both button touch areas.
		leftRadioButton.touchArea.trailingAnchor == rightRadioButton.touchArea.leadingAnchor
		leftRadioButton.touchArea.widthAnchor == rightRadioButton.touchArea.widthAnchor

		// Center the title label in between of both radio buttons.
		titleLabel.topAnchor == layoutMarginsGuide.topAnchor
		titleLabel.bottomAnchor == layoutMarginsGuide.bottomAnchor
		titleLabel.leadingAnchor == leftRadioButton.trailingAnchor + Const.Size.defaultGap
		titleLabel.trailingAnchor == rightRadioButton.leadingAnchor - Const.Size.defaultGap
		titleLabel.heightAnchor >= Const.Size.cellDefaultLabelMinHeight

		// Add the separator to the bottom.
		separatorView.leadingAnchor == layoutMarginsGuide.leadingAnchor
		separatorView.trailingAnchor == layoutMarginsGuide.trailingAnchor
		separatorView.bottomAnchor == bottomAnchor
		// A height constraint which can break for the even thicker line constraint when in large mode.
		separatorView.heightAnchor == Const.Size.separatorThicknessNormal ~ .high

		// Apply margins.
		if #available(iOS 11.0, *) {
			directionalLayoutMargins = Const.Margin.cell.directional
		} else {
			layoutMargins = Const.Margin.cell
		}

		// Set default styles.
		backgroundColor = Const.Color.darkMain
		largeStyle = { largeStyle }()
		isEnabled = true
	}

	// MARK: - Subviews

	/// The title label.
	private let titleLabel: UILabel = {
		let label = UILabel(frame: .max)
		label.textAlignment = .center
		label.textColor = Const.Color.lightMain
		label.numberOfLines = 3
		return label
	}()

	/// The left radio button.
	private let leftRadioButton: RadioButton = {
		let button = RadioButton()
		button.accessibilityIdentifier = Const.SplitRadioCellViewTests.ViewName.leftRadioButton
		button.defaultColor = Const.Color.magenta
		button.selectColor = Const.Color.magenta
		return button
	}()

	/// The right radio button.
	private let rightRadioButton: RadioButton = {
		let button = RadioButton()
		button.accessibilityIdentifier = Const.SplitRadioCellViewTests.ViewName.rightRadioButton
		button.defaultColor = Const.Color.lightMain
		button.selectColor = Const.Color.lightMain
		return button
	}()

	/// The separator at the bottom.
	private let separatorView: UIView = {
		let view = UIView(frame: .max)
		view.backgroundColor = Const.Color.lightMain
		return view
	}()

	/// The constraints used when the `largeStyle` property is `true`.
	private lazy var scaledConstraints: [NSLayoutConstraint] = {
		Anchorage.batch(active: false) {
			separatorView.heightAnchor == Const.Size.separatorThicknessLarge
		}
	}()

	// MARK: - Properties

	/// The title string.
	var title: String {
		get { return titleLabel.attributedText?.string ?? String.empty }
		set { titleLabel.attributedText = newValue.styled(with: Const.StringStyle.base) }
	}

	/// Whether the left radio button is selected.
	var leftSelected: Bool {
		get { return leftRadioButton.isSelected }
		set {
			leftRadioButton.isSelected = newValue
		}
	}

	/// Whether the right radio button is selected.
	var rightSelected: Bool {
		get { return rightRadioButton.isSelected }
		set {
			rightRadioButton.isSelected = newValue
		}
	}

	/// Whether the view uses a large style for labels and sub-views. Defaults to `false`.
	var largeStyle = false {
		didSet {
			// Apply style to subviews.
			titleLabel.font = largeStyle ? Const.Font.headline1Large : Const.Font.headline1Default
			leftRadioButton.largeStyle = largeStyle
			rightRadioButton.largeStyle = largeStyle

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
		get { return leftRadioButton.isEnabled && rightRadioButton.isEnabled }
		set {
			leftRadioButton.isEnabled = newValue
			rightRadioButton.isEnabled = newValue
		}
	}

	/// The delegate caller who informs about the left button press.
	private(set) lazy var onLeftButtonPressed: ControlCallback<SplitRadioCellView> = {
		ControlCallback(for: leftRadioButton, event: .touchUpInside) { [unowned self] in
			self
		}
	}()

	/// The delegate caller who informs about the right button press.
	private(set) lazy var onRightButtonPressed: ControlCallback<SplitRadioCellView> = {
		ControlCallback(for: rightRadioButton, event: .touchUpInside) { [unowned self] in
			self
		}
	}()

	// MARK: - Colorizing

	/// Whether the title string is highlighted or not in speech mode. `true` to highlight, `false` to de-highlight.
	/// The radio button state of the cell should NOT be changed.
	var isSpeechHighlighted = false {
		didSet {
			titleLabel.textColor = isSpeechHighlighted ? Const.Color.white : Const.Color.lightMain
		}
	}

	// MARK: - Interface Builder

	@IBInspectable private lazy var ibTitle: String = "Title"
	@IBInspectable private lazy var ibLeftSelected: Bool = leftSelected
	@IBInspectable private lazy var ibRightSelected: Bool = rightSelected
	@IBInspectable private lazy var ibSpeechHighlighted: Bool = isSpeechHighlighted
	@IBInspectable private lazy var ibLargeStyle: Bool = largeStyle

	override func prepareForInterfaceBuilder() {
		// For crashing reports look at '~/Library/Logs/DiagnosticReports/'.
		super.prepareForInterfaceBuilder()

		translatesAutoresizingMaskIntoConstraints = true
		backgroundColor = Const.Color.darkMain

		title = ibTitle
		leftSelected = ibLeftSelected
		rightSelected = ibRightSelected
		isSpeechHighlighted = ibSpeechHighlighted
		largeStyle = ibLargeStyle
	}
}
