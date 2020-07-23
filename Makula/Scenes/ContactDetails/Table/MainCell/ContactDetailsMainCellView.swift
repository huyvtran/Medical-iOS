import Anchorage
import UIKit

@IBDesignable
class ContactDetailsMainCellView: UIView {
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
		addSubview(textField)
		addSubview(dragButton)
		addSubview(arrowIcon)
		addSubview(separatorView)

		// Make the view fit the title label.
		titleLabel.topAnchor == layoutMarginsGuide.topAnchor
		titleLabel.leadingAnchor == layoutMarginsGuide.leadingAnchor
		titleLabel.trailingAnchor == arrowIcon.leadingAnchor - Const.Size.defaultGap
		titleLabel.bottomAnchor == layoutMarginsGuide.bottomAnchor
		titleLabel.heightAnchor >= Const.Size.cellDefaultLabelMinHeight

		// Place the text field on top of the label.
		textField.edgeAnchors == layoutMarginsGuide.edgeAnchors

		// The drag button goes to the left.
		dragButton.leadingAnchor == leadingAnchor
		dragButton.trailingAnchor == titleLabel.leadingAnchor
		dragButton.centerYAnchor == titleLabel.centerYAnchor

		// The arrow icon goes to the right.
		arrowIcon.trailingAnchor == layoutMarginsGuide.trailingAnchor
		arrowIcon.centerYAnchor == titleLabel.centerYAnchor
		// Make the arrow icon respect the image's aspect ratio.
		guard let image = arrowIcon.image else { fatalError() }
		arrowIcon.heightAnchor == arrowIcon.widthAnchor * image.size.height / image.size.width
		// The arrow shouldn't get compressed or pulled by the title.
		arrowIcon.horizontalCompressionResistance = .high + 1
		arrowIcon.horizontalHuggingPriority = .low + 1

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
		backgroundColor = Const.Color.darkMain
		editable = { editable }()
		actable = { actable }()
		defaultColor = { defaultColor }()
		highlightColor = { highlightColor }()
		largeStyle = { largeStyle }()
	}

	// MARK: - Subviews

	/// The view's title label.
	private let titleLabel: UILabel = {
		let label = UILabel(frame: .max)
		label.numberOfLines = 5
		return label
	}()

	/// The text field for input.
	private let textField: UITextField = {
		let textfield = UITextField(frame: .max)
		textfield.backgroundColor = UIColor.clear
		textfield.returnKeyType = .done
		textfield.borderStyle = .none
		return textfield
	}()

	/// The drag indicator button at the left.
	private let dragButton: ImageButton = {
		let button = ImageButton(type: .dragIndicator)
		return button
	}()

	/// The arrow icon at the right.
	private let arrowIcon: UIImageView = {
		let imageView = UIImageView()
		imageView.image = R.image.back_arrow()?.withHorizontallyFlippedOrientation().withRenderingMode(.alwaysTemplate)
		imageView.contentMode = .scaleAspectFit
		return imageView
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
			guard let image = arrowIcon.image else { fatalError() }
			arrowIcon.widthAnchor == image.size.width * Const.Size.landscapeScaleFactor
		}
	}()

	// MARK: - Properties

	/// Whether the view is editable or not. Defaults to `false`, the drag indicator button is hidden.
	var editable = false {
		didSet {
			dragButton.isHidden = !editable
		}
	}

	/// Whether the custom action is enable or not. Defaults to `false`, the arrow icon is hidden.
	var actable = false {
		didSet {
			arrowIcon.isHidden = !actable
		}
	}

	/// The foreground color for the default state of the cell.
	var defaultColor: UIColor = Const.Color.lightMain {
		didSet {
			textField.textColor = defaultColor
			textField.placeholderColor = defaultColor
			dragButton.defaultColor = defaultColor
			applyDefaultColor()
		}
	}

	/// The foreground color for the highlight state of the cell.
	var highlightColor = Const.Color.white {
		didSet {
			dragButton.highlightColor = highlightColor
		}
	}

	/// Whether the view uses a large font for labels or not. Defaults to `false`.
	var largeStyle = false {
		didSet {
			titleLabel.font = largeStyle ? Const.Font.headline1Large : Const.Font.headline1Default
			textField.font = largeStyle ? Const.Font.headline1Large : Const.Font.headline1Default
			dragButton.largeStyle = largeStyle

			// Apply constraints.
			if largeStyle {
				NSLayoutConstraint.activate(scaledConstraints)
			} else {
				NSLayoutConstraint.deactivate(scaledConstraints)
			}
		}
	}

	/**
	 Shows the title label instead of the text field.
	 Hides the text field.

	 - parameter title: The title to show in the label.
	 */
	func showTitle(_ title: String) {
		titleLabel.attributedText = title.styled(with: Const.StringStyle.base)
		titleLabel.isHidden = false
		textField.isHidden = true
	}

	/**
	 Shows the text field and hides the title label.

	 - parameter placeholder: The placeholder text to show in the text field when there is no title.
	 - parameter tag: The text field's tag.
	 */
	func showTextField(placeholder: String, tag: Int) {
		titleLabel.text = String.empty
		titleLabel.isHidden = true
		textField.text = nil
		textField.placeholder = placeholder
		// Re-assign the placeholder color because setting the placeholder text resets the color.
		textField.placeholderColor = defaultColor
		textField.isHidden = false
		textField.tag = tag
	}

	/// The delegate to inform about actions in the input text field.
	var textFieldDelegate: UITextFieldDelegate? {
		get { return textField.delegate }
		set { textField.delegate = newValue }
	}

	/**
	 Makes the text field the first responder.
	 */
	func makeTextFieldFirstResponder() {
		textField.becomeFirstResponder()
	}

	/// The delegate caller who informs about the drag indicator button press.
	private(set) lazy var onDragButtonPressed: ControlCallback<ContactDetailsMainCellView> = {
		ControlCallback(for: dragButton, event: .touchUpInside) { [unowned self] in
			self
		}
	}()

	// MARK: - Colorizing

	/// Whether the title string is highlighted or not in speech mode. `true` to highlight, `false` to de-highlight.
	/// The selected state of the cell should NOT be changed.
	var isSpeechHighlighted = false {
		didSet {
			if isSpeechHighlighted {
				titleLabel.textColor = highlightColor
				textField.placeholderColor = highlightColor
			} else {
				titleLabel.textColor = defaultColor
				textField.placeholderColor = defaultColor
			}
		}
	}

	/**
	 Sets the color of the views depending on the current style state.
	 */
	func applyDefaultColor() {
		backgroundColor = Const.Color.darkMain
		titleLabel.textColor = defaultColor
		arrowIcon.tintColor = defaultColor
		separatorView.backgroundColor = defaultColor
	}

	/**
	 Sets the color of views for the hightlight / selected state.
	 */
	func applyHighlightColor() {
		backgroundColor = Const.Color.darkMain
		titleLabel.textColor = highlightColor
		arrowIcon.tintColor = highlightColor
		separatorView.backgroundColor = highlightColor
	}

	// MARK: - Interface Builder

	@IBInspectable private lazy var ibTitle: String = "Title"
	@IBInspectable private lazy var ibShowTitle: Bool = true
	@IBInspectable private lazy var ibPlaceholder: String = "Placeholder"
	@IBInspectable private lazy var ibDefaultColor: UIColor = defaultColor
	@IBInspectable private lazy var ibHighlightColor: UIColor = highlightColor
	@IBInspectable private lazy var ibEditable: Bool = editable
	@IBInspectable private lazy var ibActable: Bool = actable
	@IBInspectable private lazy var ibHighlight: Bool = false
	@IBInspectable private lazy var ibLargeStyle: Bool = largeStyle

	override func prepareForInterfaceBuilder() {
		// For crashing reports look at '~/Library/Logs/DiagnosticReports/'.
		super.prepareForInterfaceBuilder()
		translatesAutoresizingMaskIntoConstraints = true

		backgroundColor = Const.Color.darkMain
		defaultColor = ibDefaultColor
		highlightColor = ibHighlightColor
		editable = ibEditable
		actable = ibActable
		largeStyle = ibLargeStyle

		if ibShowTitle {
			showTitle(ibTitle)
		} else {
			showTextField(placeholder: ibPlaceholder, tag: 0)
		}

		if ibHighlight {
			applyHighlightColor()
		}
	}
}
