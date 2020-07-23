import Anchorage
import UIKit

@IBDesignable
class SearchInputCellView: UIView {
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

		// Place the text field on top of the label.
		textField.edgeAnchors == layoutMarginsGuide.edgeAnchors

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
		largeStyle = { largeStyle }()
	}

	// MARK: - Subviews

	/// The text field for input.
	private let textField: UITextField = {
		let textfield = UITextField(frame: .zero)
		textfield.backgroundColor = UIColor.clear
		textfield.returnKeyType = .search
		textfield.autocorrectionType = .no
		textfield.borderStyle = .none
		textfield.text = nil
		textfield.textColor = Const.Color.white
		// Setting the placeholder text resets the color.
		textfield.placeholder = R.string.search.searchInputCellTextFieldPlaceholder()
		textfield.placeholderColor = Const.Color.white
		return textfield
	}()

	/// The separator at the bottom.
	private let separatorView: UIView = {
		let view = UIView(frame: .zero)
		view.backgroundColor = Const.Color.white
		return view
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
			textField.font = largeStyle ? Const.Font.headline1Large : Const.Font.headline1Default

			// Apply constraints.
			if largeStyle {
				NSLayoutConstraint.activate(scaledConstraints)
			} else {
				NSLayoutConstraint.deactivate(scaledConstraints)
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

	/// The textfield's text.
	var textFieldText: String? {
		get {
			return textField.text
		}
		set {
			if let text = newValue, !text.isEmpty {
				textField.text = text
			} else {
				textField.text = nil
				// Setting the placeholder text resets the color.
				textField.placeholder = R.string.search.searchInputCellTextFieldPlaceholder()
				textField.placeholderColor = Const.Color.white
			}
		}
	}

	// MARK: - Interface Builder

	@IBInspectable private lazy var ibLargeStyle: Bool = largeStyle

	override func prepareForInterfaceBuilder() {
		// For crashing reports look at '~/Library/Logs/DiagnosticReports/'.
		super.prepareForInterfaceBuilder()

		translatesAutoresizingMaskIntoConstraints = true

		backgroundColor = Const.Color.darkMain
		largeStyle = ibLargeStyle
	}
}
