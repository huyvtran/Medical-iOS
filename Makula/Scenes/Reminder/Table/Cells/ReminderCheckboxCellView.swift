import Anchorage
import UIKit

@IBDesignable
class ReminderCheckboxCellView: UIView {
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
		addSubview(radioButton)
		addSubview(separatorView)

		// Make the view fit the title label.
		titleLabel.leadingAnchor == layoutMarginsGuide.leadingAnchor
		titleLabel.topAnchor == layoutMarginsGuide.topAnchor
		titleLabel.trailingAnchor == radioButton.leadingAnchor - Const.Size.defaultGap
		titleLabel.bottomAnchor == layoutMarginsGuide.bottomAnchor
		titleLabel.horizontalCompressionResistance = .high - 1
		titleLabel.horizontalHuggingPriority = .low - 1
		titleLabel.heightAnchor >= Const.Size.cellDefaultLabelMinHeight

		// The radio button goes to the right.
		radioButton.trailingAnchor == layoutMarginsGuide.trailingAnchor
		radioButton.centerYAnchor == titleLabel.centerYAnchor

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
		applyDefaultColor()
		largeStyle = { largeStyle }()
	}

	// MARK: - Subviews

	/// The view's title label.
	private let titleLabel: UILabel = {
		let label = UILabel(frame: .max)
		label.numberOfLines = 0
		label.text = R.string.reminder.checkboxTitle()
		return label
	}()

	/// The separator at the bottom.
	private let separatorView: UIView = {
		let view = UIView(frame: .max)
		return view
	}()

	/// The radio button at the right.
	private let radioButton: RadioButton = {
		let button = RadioButton()
		// Disabled because oherwise the cell won't receive the touch, but this button.
		button.isEnabled = false
		button.defaultColor = Const.Color.lightMain
		button.selectColor = Const.Color.magenta
		return button
	}()

	/// The constraints used when the `largeStyle` property is `true`.
	private lazy var scaledConstraints: [NSLayoutConstraint] = {
		Anchorage.batch(active: false) {
			separatorView.heightAnchor == Const.Size.separatorThicknessLarge
		}
	}()

	// MARK: - Properties

	/// Whether the view uses a large font for labels or not. Defaults to `false`.
	var largeStyle = false {
		didSet {
			radioButton.largeStyle = largeStyle
			titleLabel.font = largeStyle ? Const.Font.headline1Large : Const.Font.headline1Default

			// Apply constraints.
			if largeStyle {
				NSLayoutConstraint.activate(scaledConstraints)
			} else {
				NSLayoutConstraint.deactivate(scaledConstraints)
			}
		}
	}

	// MARK: - Colorizing

	/// Whether the cell is selected or not. `true` to select, `false` to deselect.
	private var isHighlighted = false

	/**
	 Sets the color of the views depending on the current style state.
	 */
	func applyDefaultColor() {
		isHighlighted = false
		backgroundColor = Const.Color.darkMain
		separatorView.backgroundColor = Const.Color.lightMain
		titleLabel.textColor = Const.Color.lightMain
		radioButton.isSelected = false
	}

	/**
	 Sets the color of views for the hightlight / selected state.
	 */
	func applyHighlightColor() {
		isHighlighted = true
		backgroundColor = Const.Color.darkMain
		separatorView.backgroundColor = Const.Color.lightMain
		titleLabel.textColor = Const.Color.magenta
		radioButton.isSelected = true
	}

	// MARK: - Interface Builder

	@IBInspectable private lazy var ibLargeStyle: Bool = largeStyle
	@IBInspectable private lazy var ibHighlight: Bool = false

	override func prepareForInterfaceBuilder() {
		// For crashing reports look at '~/Library/Logs/DiagnosticReports/'.
		super.prepareForInterfaceBuilder()

		translatesAutoresizingMaskIntoConstraints = true
		backgroundColor = Const.Color.lightMain
		largeStyle = ibLargeStyle

		if ibHighlight {
			applyHighlightColor()
		}
	}
}
