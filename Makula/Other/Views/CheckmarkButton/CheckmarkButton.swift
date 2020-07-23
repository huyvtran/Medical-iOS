import Anchorage
import UIKit

/**
 A checkmark toggle button with a checkmark in a circle.
 The checkmark is shown when in `on` state and hidden in `off` state.
 */
@IBDesignable
class CheckmarkButton: UIButton {
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
		accessibilityIdentifier = Const.CheckmarkButtonTests.ViewName.buttonView

		// Create view hierarchy.
		addSubview(circleImageView)
		addSubview(checkmarkImageView)

		// The circle defines the button's size.
		circleImageView.edgeAnchors == edgeAnchors

		// Make the circle use the image's ratio.
		guard let image = circleImageView.image else { fatalError() }
		circleImageView.heightAnchor == circleImageView.widthAnchor * image.size.height / image.size.width

		// Place the checkmark icon on top of the circle.
		checkmarkImageView.edgeAnchors == circleImageView.edgeAnchors

		// Set default styles.
		checked = { checked }()
		largeStyle = { largeStyle }()
	}

	override var intrinsicContentSize: CGSize {
		// The intrinsic content size is the image's size.
		guard let image = circleImageView.image else { fatalError() }
		return image.size
	}

	// MARK: - Subviews

	/// The image view showing the circle icon.
	private let circleImageView: UIImageView = {
		let imageView = UIImageView(image: R.image.checkmark_circle())
		imageView.accessibilityIdentifier = Const.CheckmarkButtonTests.ViewName.circleImageView
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()

	/// The image view showing the checkmark on top of the circle icon.
	private let checkmarkImageView: UIImageView = {
		let imageView = UIImageView(image: R.image.checkmark_check())
		imageView.accessibilityIdentifier = Const.CheckmarkButtonTests.ViewName.checkmarkImageView
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()

	/// The constraints used when the `largeStyle` property is `true`.
	private lazy var scaledConstraints: [NSLayoutConstraint] = {
		Anchorage.batch(active: false) {
			guard let image = circleImageView.image else { fatalError() }
			circleImageView.widthAnchor == image.size.width * Const.Size.landscapeScaleFactor
		}
	}()

	// MARK: - Properties

	/// The checked state, `true` shows the checkmark, `false` (default) hides it.
	var checked: Bool = false {
		didSet {
			checkmarkImageView.isHidden = !checked
		}
	}

	/// Whether the button is shown in large mode ('true') or in normal mode (`false`). Defaults to `false`.
	var largeStyle: Bool = false {
		didSet {
			// Apply constraints.
			if largeStyle {
				NSLayoutConstraint.activate(scaledConstraints)
			} else {
				NSLayoutConstraint.deactivate(scaledConstraints)
			}
		}
	}

	// MARK: - Interface Builder

	@IBInspectable private lazy var ibBgColor: UIColor = Const.Color.darkMain
	@IBInspectable private lazy var ibChecked: Bool = checked
	@IBInspectable private lazy var ibLargeStyle: Bool = largeStyle

	override func prepareForInterfaceBuilder() {
		// For crashing reports look at '~/Library/Logs/DiagnosticReports/'.
		super.prepareForInterfaceBuilder()
		translatesAutoresizingMaskIntoConstraints = true

		backgroundColor = ibBgColor
		checked = ibChecked
		largeStyle = ibLargeStyle
	}
}
