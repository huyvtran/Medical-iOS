import Anchorage
import UIKit

/**
 A typical button for user confirmation with a title in the center and an optional arrow icon at the right.
 */
@IBDesignable
class ConfirmButton: UIButton {
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
		accessibilityIdentifier = Const.ConfirmButtonTests.ViewName.buttonView

		// Create view hierarchy.
		addSubview(arrowIcon)
		addSubview(title)

		// Min height for this button.
		heightAnchor >= 60

		// Put the arrow to the right in the vertical center.
		arrowIcon.trailingAnchor == layoutMarginsGuide.trailingAnchor
		arrowIcon.centerYAnchor == centerYAnchor
		guard let arrowIconImage = arrowIcon.image else { fatalError() }
		arrowIcon.heightAnchor == arrowIcon.widthAnchor * arrowIconImage.size.height / arrowIconImage.size.width

		// The title label is centered, but respects the arrow icon.
		title.centerXAnchor == centerXAnchor
		title.centerYAnchor == centerYAnchor
		title.topAnchor >= layoutMarginsGuide.topAnchor
		title.bottomAnchor <= layoutMarginsGuide.bottomAnchor
		title.trailingAnchor <= arrowIcon.leadingAnchor - Const.Size.defaultGap
		title.horizontalCompressionResistance = .high - 10

		// Apply margins.
		if #available(iOS 11.0, *) {
			directionalLayoutMargins = Const.ConfirmButton.Margin.content.directional
		} else {
			layoutMargins = Const.ConfirmButton.Margin.content
		}

		// Set default styles.
		isEnabled = { isEnabled }()
		arrowVisible = { arrowVisible }()
		largeStyle = { largeStyle }()
	}

	// MARK: - Subviews

	/// The arrow icon at the right.
	private let arrowIcon: UIImageView = {
		let arrow = UIImageView()
		arrow.image = R.image.back_arrow()?.withHorizontallyFlippedOrientation().withRenderingMode(.alwaysTemplate)
		arrow.contentMode = .scaleAspectFit
		arrow.tintColor = arrowIconDefaultTintColor
		return arrow
	}()

	/// The default tint color for the arrow icon.
	private static let arrowIconDefaultTintColor = Const.Color.darkMain

	/// The tint color for the arrow icon when highlighted.
	private static let arrowIconHighlightTintColor = Const.Color.white

	/// The title label in the center.
	private let title: UILabel = {
		let title = UILabel()
		title.textColor = titleDefaultTextColor
		title.textAlignment = .center
		title.numberOfLines = Const.ConfirmButton.maxTitleLines
		return title
	}()

	/// The default text color for the title label.
	private static let titleDefaultTextColor = Const.Color.darkMain

	/// The text color for the title label when highlighted.
	private static let titleHighlightTextColor = Const.Color.white

	/// The constraints used when the `largeStyle` property is `true`.
	private lazy var scaledConstraints: [NSLayoutConstraint] = {
		guard let image = arrowIcon.image else { fatalError() }
		return Anchorage.batch(active: false) {
			arrowIcon.widthAnchor == image.size.width * Const.Size.landscapeScaleFactor
		}
	}()

	// MARK: - Properties

	/// The text of the title label.
	var titleText: String {
		get { return title.attributedText?.string ?? String.empty }
		set { title.attributedText = newValue.styled(with: Const.StringStyle.base) }
	}

	/// The visibility state of the arrow icon. Set to `false` to hide it, `true` (default) to show it.
	var arrowVisible = true {
		didSet {
			arrowIcon.isHidden = !arrowVisible
		}
	}

	/// Whether the button is shown in large mode ('true') or in normal mode (`false`). Defaults to `false`.
	var largeStyle: Bool = false {
		didSet {
			// Update the text font to use the new style.
			title.font = largeStyle ? Const.Font.headline1Large : Const.Font.headline1Default
			// Apply constraints.
			if largeStyle {
				NSLayoutConstraint.activate(scaledConstraints)
			} else {
				NSLayoutConstraint.deactivate(scaledConstraints)
			}
		}
	}

	override var isHighlighted: Bool {
		didSet {
			title.textColor = isHighlighted ? ConfirmButton.titleHighlightTextColor : ConfirmButton.titleDefaultTextColor
			arrowIcon.tintColor = isHighlighted ? ConfirmButton.arrowIconHighlightTintColor : ConfirmButton.arrowIconDefaultTintColor
		}
	}

	override var isEnabled: Bool {
		didSet {
			backgroundColor = isEnabled ? Const.Color.lightMain : Const.Color.disabled
		}
	}

	// MARK: - Interface Builder

	@IBInspectable private lazy var ibBgColor: UIColor = Const.Color.lightMain
	@IBInspectable private lazy var ibTitleText: String = "Title"
	@IBInspectable private lazy var ibArrowVisible: Bool = arrowVisible
	@IBInspectable private lazy var ibHighlighted: Bool = isHighlighted
	@IBInspectable private lazy var ibEnabled: Bool = isEnabled
	@IBInspectable private lazy var ibLargeStyle: Bool = largeStyle

	override func prepareForInterfaceBuilder() {
		// For crashing reports look at '~/Library/Logs/DiagnosticReports/'.
		super.prepareForInterfaceBuilder()
		translatesAutoresizingMaskIntoConstraints = true

		backgroundColor = ibBgColor
		titleText = ibTitleText
		arrowVisible = ibArrowVisible
		isHighlighted = ibHighlighted
		isEnabled = ibEnabled
		largeStyle = ibLargeStyle
	}
}
