import Anchorage
import UIKit

/**
 A radio option button.
 */
@IBDesignable
class RadioButton: UIButton {
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
		accessibilityIdentifier = Const.RadioButtonTests.ViewName.buttonView

		// Create view hierarchy.
		addSubview(normalImageView)
		addSubview(selectImageView)
		addSubview(touchArea)

		// The circle defines the button's size.
		normalImageView.edgeAnchors == edgeAnchors

		// Make the view use the image's ratio.
		guard let image = normalImageView.image else { fatalError() }
		normalImageView.heightAnchor == normalImageView.widthAnchor * image.size.height / image.size.width

		// Place the selected icon on top of the non-selected.
		selectImageView.edgeAnchors == normalImageView.edgeAnchors

		// Add default breakable constraints for the touch area around this button with a min size applied.
		touchArea.edgeAnchors == edgeAnchors ~ .low - 1
		touchArea.centerAnchors == centerAnchors ~ .low - 2
		touchArea.widthAnchor >= UIButton.buttonMinSize.width ~ .high
		touchArea.heightAnchor >= UIButton.buttonMinSize.height ~ .high

		// Set default style
		isSelected = { isSelected }()
		largeStyle = { largeStyle }()
		defaultColor = { defaultColor }()
		selectColor = { selectColor }()
		isSelected = { isSelected }()
	}

	override var intrinsicContentSize: CGSize {
		// The intrinsic content size is the image's size.
		guard let image = normalImageView.image else { fatalError() }
		return image.size
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

	/// The image view showing the empty circle icon for the non-selection state.
	private let normalImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = R.image.checkbox_unselected()?.withRenderingMode(.alwaysTemplate)
		imageView.accessibilityIdentifier = Const.RadioButtonTests.ViewName.circleImageView
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()

	/// The image view showing the selected state with a solid circle.
	private let selectImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = R.image.checkbox_selected()?.withRenderingMode(.alwaysTemplate)
		imageView.accessibilityIdentifier = Const.RadioButtonTests.ViewName.radioImageView
		imageView.contentMode = .scaleAspectFit
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

	/// The constraints used when the `largeStyle` property is `true`.
	private lazy var scaledConstraints: [NSLayoutConstraint] = {
		Anchorage.batch(active: false) {
			guard let image = normalImageView.image else { fatalError() }
			normalImageView.widthAnchor == image.size.width * Const.Size.landscapeScaleFactor
		}
	}()

	// MARK: - Properties

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

	/// The tint color of the non-selected state.
	var defaultColor: UIColor = Const.Color.lightMain {
		didSet {
			normalImageView.tintColor = defaultColor
		}
	}

	/// The tint color of the selected state.
	var selectColor: UIColor = Const.Color.magenta {
		didSet {
			selectImageView.tintColor = selectColor
		}
	}

	override var isSelected: Bool {
		didSet {
			normalImageView.isHidden = isSelected
			selectImageView.isHidden = !isSelected
		}
	}

	// MARK: - Interface Builder

	@IBInspectable private lazy var ibBgColor: UIColor = Const.Color.darkMain
	@IBInspectable private lazy var ibSelected: Bool = isSelected
	@IBInspectable private lazy var ibLargeStyle: Bool = largeStyle
	@IBInspectable private lazy var ibDefaultColor: UIColor = defaultColor
	@IBInspectable private lazy var ibSelectColor: UIColor = selectColor

	override func prepareForInterfaceBuilder() {
		// For crashing reports look at '~/Library/Logs/DiagnosticReports/'.
		super.prepareForInterfaceBuilder()
		translatesAutoresizingMaskIntoConstraints = true

		backgroundColor = ibBgColor
		isSelected = ibSelected
		largeStyle = ibLargeStyle
		defaultColor = ibDefaultColor
		selectColor = ibSelectColor
	}
}
