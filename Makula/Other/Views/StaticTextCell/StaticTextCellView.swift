import Anchorage
import UIKit

@IBDesignable
class StaticTextCellView: UIView {
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
		addSubview(separatorView)

		// Make the view fit the title label.
		titleLabel.edgeAnchors == layoutMarginsGuide.edgeAnchors
		titleLabel.heightAnchor >= Const.Size.cellDefaultLabelMinHeight

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
		largeStyle = { largeStyle }()
		separatorVisible = { separatorVisible }()
		centeredText = { centeredText }()
		applyDefaultColor()
	}

	// MARK: - Subviews

	/// The view's title label.
	private let titleLabel: UILabel = {
		let label = UILabel(frame: .max)
		label.numberOfLines = 0
		return label
	}()

	/// The separator at the bottom.
	private let separatorView: UIView = {
		let view = UIView(frame: .max)
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

	/// Whether the view uses a large style for labels and sub-views. Defaults to `false`.
	var largeStyle = false {
		didSet {
			titleLabel.font = largeStyle ? Const.Font.headline1Large : Const.Font.headline1Default

			// Apply constraints.
			if largeStyle {
				NSLayoutConstraint.activate(scaledConstraints)
			} else {
				NSLayoutConstraint.deactivate(scaledConstraints)
			}
		}
	}

	/// The tint color for normal mode (not highlighted).
	var defaultColor: UIColor = Const.Color.lightMain {
		didSet {
			titleLabel.textColor = defaultColor
		}
	}

	/// The tint color for highlight mode.
	var highlightColor: UIColor = Const.Color.white

	/// The view's background color.
	var backColor: UIColor = Const.Color.darkMain {
		didSet {
			backgroundColor = backColor
		}
	}

	/// The visibility state of the separator line. Set to `false` to hide it, `true` (default) to show it.
	var separatorVisible = true {
		didSet {
			separatorView.isHidden = !separatorVisible
		}
	}

	/// The color of the separator for normal mode (not highlighted).
	var separatorDefaultColor: UIColor = Const.Color.lightMain {
		didSet {
			separatorView.backgroundColor = separatorDefaultColor
		}
	}

	/// The color of the separator for highlight mode.
	var separatorHighlightColor: UIColor = Const.Color.white

	/// Whether the text in the label is centered or left aligned.
	var centeredText = false {
		didSet {
			titleLabel.textAlignment = centeredText ? .center : .left
		}
	}

	// MARK: - Colorizing

	/**
	 Sets the color of the views depending on the current style state.
	 */
	func applyDefaultColor() {
		backgroundColor = backColor
		titleLabel.textColor = defaultColor
		separatorView.backgroundColor = separatorDefaultColor
	}

	/**
	 Sets the color of views for the hightlight / selected state.
	 */
	func applyHighlightColor() {
		backgroundColor = backColor
		titleLabel.textColor = highlightColor
		separatorView.backgroundColor = separatorHighlightColor
	}

	// MARK: - Interface Builder

	@IBInspectable private lazy var ibTitle: String = "Title"
	@IBInspectable private lazy var ibDefaultColor: UIColor = defaultColor
	@IBInspectable private lazy var ibHighlightColor: UIColor = highlightColor
	@IBInspectable private lazy var ibBackColor: UIColor = backColor
	@IBInspectable private lazy var ibSeparator: Bool = separatorVisible
	@IBInspectable private lazy var ibSepNormalColor: UIColor = separatorDefaultColor
	@IBInspectable private lazy var ibSepHighlightColor: UIColor = separatorHighlightColor
	@IBInspectable private lazy var ibLargeStyle: Bool = largeStyle
	@IBInspectable private lazy var ibHighlight: Bool = false
	@IBInspectable private lazy var ibCenteredText: Bool = false

	override func prepareForInterfaceBuilder() {
		// For crashing reports look at '~/Library/Logs/DiagnosticReports/'.
		super.prepareForInterfaceBuilder()

		translatesAutoresizingMaskIntoConstraints = true
		title = ibTitle
		defaultColor = ibDefaultColor
		highlightColor = ibHighlightColor
		backColor = ibBackColor
		separatorVisible = ibSeparator
		separatorDefaultColor = ibSepNormalColor
		separatorHighlightColor = ibSepHighlightColor
		largeStyle = ibLargeStyle
		centeredText = ibCenteredText

		if ibHighlight {
			applyHighlightColor()
		}
	}
}
