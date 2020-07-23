import Anchorage
import UIKit

/**
 The cell view with a text field.
 */
@IBDesignable
class MedicamentInputCellView: UIView {
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
		addSubview(textField)
		addSubview(separatorView)

		// Make the view fit the text field.
		textField.edgeAnchors == layoutMarginsGuide.edgeAnchors
		textField.heightAnchor >= Const.Size.cellDefaultLabelMinHeight

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
	}

	// MARK: - Subviews

	/// The text field for input.
	private let textField: UITextField = {
		let textfield = UITextField(frame: .max)
		textfield.backgroundColor = UIColor.clear
		textfield.textColor = Const.Color.lightMain
		textfield.placeholder = R.string.medicament.cellMore()
		textfield.placeholderColor = Const.Color.lightMain
		textfield.returnKeyType = .done
		textfield.borderStyle = .none
		return textfield
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

	/// The text string of the text field.
	var textFieldString: String {
		get { return textField.attributedText?.string ?? String.empty }
		set { textField.attributedText = newValue.styled(with: Const.StringStyle.base) }
	}

	/// Whether the view uses a large font for labels or not. Defaults to `false`.
	var largeStyle = false {
		didSet {
			textField.font = largeStyle ? Const.Font.headline1Large : Const.Font.headline1Default

			// Apply constraints.
			if largeStyle {
				NSLayoutConstraint.activate(scaledConstraints)
			} else {
				NSLayoutConstraint.deactivate(scaledConstraints)
			}
		}
	}

	/// Whether the place holder string is highlighted or not. `true` to highlight, `false` to de-highlight.
	var isSpeechHighlighted = false {
		didSet {
			if isSpeechHighlighted {
				textField.placeholder = R.string.medicament.cellMore()
				textField.placeholderColor = Const.Color.white
			} else {
				textField.placeholder = R.string.medicament.cellMore()
				textField.placeholderColor = Const.Color.lightMain
			}
		}
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

	// MARK: - Interface Builder

	@IBInspectable private lazy var ibTextField: String = ""
	@IBInspectable private lazy var ibLargeStyle: Bool = false

	override func prepareForInterfaceBuilder() {
		// For crashing reports look at '~/Library/Logs/DiagnosticReports/'.
		super.prepareForInterfaceBuilder()

		translatesAutoresizingMaskIntoConstraints = true
		backgroundColor = Const.Color.darkMain
		textFieldString = ibTextField
		largeStyle = ibLargeStyle
	}
}
