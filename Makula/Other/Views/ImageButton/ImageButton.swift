import Anchorage
import UIKit

/**
 A push button as a replacement for `UIButton` with a specific design type.

 The button's images for normal and highlight state have to be equal in width and height.
 */
@IBDesignable
class ImageButton: UIButton {
	// MARK: - Init

	@available(*, unavailable)
	init() {
		// Needs to be marked explicitly as unavailable otherwise it will be available by UIView
		// which would call `init(frame:)` instead.
		fatalError()
	}

	init(type: ImageButtonType) {
		super.init(frame: .max)
		configureView(type: type)
	}

	@available(*, unavailable)
	override init(frame: CGRect) {
		// Needed to render in InterfaceBuilder.
		super.init(frame: frame)
		configureView(type: .back)
	}

	@available(*, unavailable, message: "Instantiating via Xib & Storyboard is prohibited.")
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	/**
	 Builds up the view hierarchy and applies the layout.

	 - parameter type: The button's initial type.
	 */
	private func configureView(type: ImageButtonType) {
		translatesAutoresizingMaskIntoConstraints = false
		accessibilityIdentifier = Const.ImageButtonTests.ViewName.buttonView

		// Create view hierarchy.
		addSubview(normalImageView)
		addSubview(highlightImageView)
		addSubview(touchArea)

		// The normal image is centered in this button so the button's size doesn't change the image's size.
		normalImageView.centerAnchors == centerAnchors

		// Place the highlight image on top of the normal image with the same size.
		highlightImageView.edgeAnchors == normalImageView.edgeAnchors

		// Add default breakable constraints for the touch area around this button with a min size applied.
		touchArea.edgeAnchors == edgeAnchors ~ .low - 1
		touchArea.centerAnchors == centerAnchors ~ .low - 2
		touchArea.widthAnchor >= UIButton.buttonMinSize.width ~ .high
		touchArea.heightAnchor >= UIButton.buttonMinSize.height ~ .high

		// Set default styles.
		self.type = type
		largeStyle = { largeStyle }()
		defaultColor = { defaultColor }()
		highlightColor = { highlightColor }()
	}

	override var intrinsicContentSize: CGSize {
		// The intrinsic content size is the image's size.
		guard let image = normalImageView.image else { fatalError() }
		let scaleFactor = largeStyle ? Const.Size.landscapeScaleFactor : 1.0
		return CGSize(width: image.size.width * scaleFactor, height: image.size.height * scaleFactor)
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

	/// The image view showing the icon in normal state.
	private let normalImageView: UIImageView = {
		let imageView = UIImageView(image: nil)
		imageView.accessibilityIdentifier = Const.ImageButtonTests.ViewName.normalImageView
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()

	/// The image view showing the icon in highlighted state.
	private let highlightImageView: UIImageView = {
		let imageView = UIImageView(image: nil)
		imageView.accessibilityIdentifier = Const.ImageButtonTests.ViewName.highlightImageView
		imageView.contentMode = .scaleAspectFit
		imageView.isHidden = true
		return imageView
	}()

	/// The touch area this button uses for detecting touches.
	/// This is an invisible view which can be used to make the touch area larger than the button by assigning constraints to it.
	let touchArea: UIView = {
		let view = UIView(frame: .max)
		view.backgroundColor = .clear
		view.isOpaque = false
		view.isUserInteractionEnabled = true
		return view
	}()

	/// The constraint to make sure the image's aspect ratio is respected.
	private var aspectRatioConstraint: NSLayoutConstraint?

	/// The constraints used when the `largeStyle` property is `true`.
	private var scaledConstraints: [NSLayoutConstraint]?

	/// A cancellable dispatch block which resets the view colors after some time.
	private lazy var dehighlightWorker = DispatchedCall(for: self) { strongSelf in
		strongSelf.normalImageView.isHidden = false
		strongSelf.highlightImageView.isHidden = true
	}

	// MARK: - Properties

	/// The button types this can represent.
	enum ImageButtonType: Int {
		/// A default back button showing the arrow to the left.
		case back
		/// The add button showing the '+' icon.
		case add
		/// The info button showing the 'i' icon.
		case info
		/// The info button showing the 'i' icon in navigation view.
		case navInfo
		/// The speaker button for starting the speech synthesizer.
		case speaker
		/// The 3-dot drag indicator button.
		case dragIndicator
	}

	/// Which type this button represents.
	var type = ImageButtonType.back {
		didSet {
			// Switch image representation.
			switch type {
			case .back:
				normalImageView.image = R.image.back_arrow()
				highlightImageView.image = R.image.back_arrow()
			case .add:
				normalImageView.image = R.image.add()
				highlightImageView.image = R.image.add()
			case .info:
				normalImageView.image = R.image.infobutton_normal()
				highlightImageView.image = R.image.infobutton_selected()
			case .navInfo:
				normalImageView.image = R.image.infobutton_selected()
				highlightImageView.image = R.image.infobutton_selected()
			case .speaker:
				normalImageView.image = R.image.speaker()
				highlightImageView.image = R.image.speaker()
			case .dragIndicator:
				normalImageView.image = R.image.threedots()?.withRenderingMode(.alwaysTemplate)
				defaultColor = { defaultColor }()
				highlightImageView.image = R.image.threedots()?.withRenderingMode(.alwaysTemplate)
				highlightColor = { highlightColor }()
			}

			// Make the view use the image's ratio.
			guard let image = normalImageView.image else { fatalError() }
			aspectRatioConstraint?.isActive = false
			aspectRatioConstraint = normalImageView.heightAnchor == normalImageView.widthAnchor * image.size.height / image.size.width

			// Create the scaled constraints for the large style.
			if let scaledConstraints = scaledConstraints {
				NSLayoutConstraint.deactivate(scaledConstraints)
			}
			scaledConstraints = Anchorage.batch(active: largeStyle) {
				normalImageView.widthAnchor == image.size.width * Const.Size.landscapeScaleFactor
			}
		}
	}

	/// The tint color of normal image view.
	var defaultColor: UIColor = Const.Color.lightMain {
		didSet {
			normalImageView.tintColor = defaultColor
		}
	}

	/// The tint color of highlight image view.
	var highlightColor: UIColor = Const.Color.white {
		didSet {
			highlightImageView.tintColor = highlightColor
		}
	}

	/// Whether the button is shown in large mode ('true') or in normal mode (`false`). Defaults to `false`.
	var largeStyle: Bool = false {
		didSet {
			// Apply constraints.
			guard let scaledConstraints = scaledConstraints else { return }
			if largeStyle {
				NSLayoutConstraint.activate(scaledConstraints)
			} else {
				NSLayoutConstraint.deactivate(scaledConstraints)
			}
		}
	}

	/// The highlighted state.
	override var isHighlighted: Bool {
		didSet {
			if isHighlighted {
				normalImageView.isHidden = true
				highlightImageView.isHidden = false
			} else {
				// Delay de-highlighting
				dehighlightWorker.enqueue(for: Const.Time.defaultAnimationDuration)
			}
		}
	}

	// MARK: - Interface Builder

	@IBInspectable private lazy var ibBgColor: UIColor = Const.Color.darkMain
	@IBInspectable private lazy var ibType: Int = type.rawValue
	@IBInspectable private lazy var ibLargeStyle: Bool = largeStyle
	@IBInspectable private lazy var ibHighlighted: Bool = isHighlighted

	override func prepareForInterfaceBuilder() {
		// For crashing reports look at '~/Library/Logs/DiagnosticReports/'.
		super.prepareForInterfaceBuilder()
		translatesAutoresizingMaskIntoConstraints = true

		backgroundColor = ibBgColor
		type = ImageButtonType(rawValue: ibType) ?? .back
		largeStyle = ibLargeStyle

		if ibHighlighted {
			isHighlighted = true
		}
	}
}
