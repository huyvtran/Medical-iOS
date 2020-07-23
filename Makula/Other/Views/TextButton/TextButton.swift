import Anchorage
import UIKit

/**
 A push button for displaying text as a replacement for `UIButton`.
 */
@IBDesignable
class TextButton: UIButton {
	// MARK: - Init

	init() {
		super.init(frame: .zero)
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
		accessibilityIdentifier = Const.ImageButtonTests.ViewName.buttonView

		// Create view hierarchy.
		addSubview(label)
		addSubview(touchArea)

		// The button defines the label's size.
		label.edgeAnchors == layoutMarginsGuide.edgeAnchors

		// Add default breakable constraints for the touch area around this button with a min size applied.
		touchArea.edgeAnchors == edgeAnchors ~ .low - 1
		touchArea.centerAnchors == centerAnchors ~ .low - 2
		touchArea.widthAnchor >= UIButton.buttonMinSize.width ~ .high
		touchArea.heightAnchor >= UIButton.buttonMinSize.height ~ .high

		// Set default styles.
		defaultColor = { defaultColor }()
		largeStyle = { largeStyle }()
		commonMargin = { commonMargin }()
	}

	override var intrinsicContentSize: CGSize {
		// The intrinsic content size is the label's size.
		let labelSize = label.intrinsicContentSize
		return labelSize
	}

	override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		guard isEnabled, !isHidden else { return nil }
		return self.point(inside: point, with: event) ? self : nil
	}

	override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
		// Make the button react to touches inside of the touch area.
		let rect = convert(touchArea.frame, from: touchArea.superview)
		return rect.contains(point)
	}

	// MARK: - Subviews

	/// The title label.
	private let label: UILabel = {
		let label = UILabel()
		label.accessibilityIdentifier = Const.TextButtonTests.ViewName.label
		label.numberOfLines = 0
		label.lineBreakMode = NSLineBreakMode.byClipping
		return label
	}()

	/// The touch area this button uses for detecting touches.
	/// This is an invisible view which can be used to make the touch area larger than the button by assigning constraints to it.
	let touchArea: UIView = {
		let view = UIView(frame: .zero)
		view.backgroundColor = .clear
		view.isOpaque = false
		view.isUserInteractionEnabled = true
		return view
	}()

	/// A cancellable dispatch block which resets the view colors after some time.
	private lazy var dehighlightWorker = DispatchedCall(for: self) { strongSelf in
		strongSelf.label.textColor = strongSelf.defaultColor
	}

	// MARK: - Properties

	/// The title's string.
	var title: String {
		get { return label.attributedText?.string ?? String.empty }
		set { label.attributedText = newValue.styled(with: Const.StringStyle.base) }
	}

	/// The title's text alignment.
	var titleTextAlignment: NSTextAlignment {
		get { return label.textAlignment }
		set { label.textAlignment = newValue }
	}

	/// The title's color in normal mode (not highlighted).
	var defaultColor: UIColor = Const.Color.lightMain {
		didSet {
			label.textColor = defaultColor
		}
	}

	/// The title's color in highlight mode.
	var highlightColor: UIColor = Const.Color.white

	/// Whether the button is shown in large mode ('true') or in normal mode (`false`). Defaults to `false`.
	var largeStyle: Bool = false {
		didSet {
			// Update the text font to use the new style.
			label.font = largeStyle ? Const.Font.headline1Large : Const.Font.headline1Default
		}
	}

	/// Activates the common margin for the inner button or zeroes it out when disabled.
	var commonMargin = true {
		didSet {
			if commonMargin {
				// Apply margins.
				if #available(iOS 11.0, *) {
					directionalLayoutMargins = Const.ConfirmButton.Margin.content.directional
				} else {
					layoutMargins = Const.ConfirmButton.Margin.content
				}
			} else {
				if #available(iOS 11.0, *) {
					directionalLayoutMargins = .zero
				} else {
					layoutMargins = .zero
				}
			}
		}
	}

	override var isHighlighted: Bool {
		didSet {
			guard !isSelected else { return }

			if isHighlighted {
				label.textColor = highlightColor
			} else {
				// Delay de-highlighting
				dehighlightWorker.enqueue(for: Const.Time.defaultAnimationDuration)
			}
		}
	}

	override var isSelected: Bool {
		didSet {
			dehighlightWorker.cancel()
			if isSelected {
				label.textColor = highlightColor
			} else {
				label.textColor = defaultColor
			}
		}
	}

	// MARK: - Interface Builder

	@IBInspectable private lazy var ibBgColor: UIColor = Const.Color.darkMain
	@IBInspectable private lazy var ibTitle: String = "Title"
	@IBInspectable private lazy var ibAlignment: Int = titleTextAlignment.rawValue
	@IBInspectable private lazy var ibLargeStyle: Bool = largeStyle
	@IBInspectable private lazy var ibDefaultColor: UIColor = defaultColor
	@IBInspectable private lazy var ibHighlightColor: UIColor = highlightColor
	@IBInspectable private lazy var ibHighlighted: Bool = isHighlighted
	@IBInspectable private lazy var ibSelected: Bool = isSelected

	override func prepareForInterfaceBuilder() {
		// For crashing reports look at '~/Library/Logs/DiagnosticReports/'.
		super.prepareForInterfaceBuilder()
		translatesAutoresizingMaskIntoConstraints = true

		backgroundColor = ibBgColor
		title = ibTitle
		titleTextAlignment = NSTextAlignment(rawValue: ibAlignment) ?? .left
		largeStyle = ibLargeStyle
		defaultColor = ibDefaultColor
		highlightColor = ibHighlightColor

		if ibHighlighted {
			isHighlighted = true
		} else if ibSelected {
			isSelected = true
		}
	}
}
