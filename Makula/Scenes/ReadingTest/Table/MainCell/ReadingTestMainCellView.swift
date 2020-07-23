import Anchorage
import UIKit

@IBDesignable
class ReadingTestMainCellView: UIView {
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
		addSubview(contentLabel)
		addSubview(leftRadioButton)
		addSubview(rightRadioButton)
		addSubview(separatorView)

		// The left radio button goes to the left.
		leftRadioButton.leadingAnchor == layoutMarginsGuide.leadingAnchor
		leftRadioButton.centerYAnchor == contentLabel.centerYAnchor

		// The right radio button goes to the right.
		rightRadioButton.trailingAnchor == layoutMarginsGuide.trailingAnchor
		rightRadioButton.centerYAnchor == contentLabel.centerYAnchor

		// The left button's touch area takse the left half.
		leftRadioButton.touchArea.leadingAnchor == layoutMarginsGuide.leadingAnchor
		leftRadioButton.touchArea.topAnchor == layoutMarginsGuide.topAnchor
		leftRadioButton.touchArea.bottomAnchor == layoutMarginsGuide.bottomAnchor

		// The right button's touch area takse the right half.
		rightRadioButton.touchArea.trailingAnchor == layoutMarginsGuide.trailingAnchor
		rightRadioButton.touchArea.topAnchor == layoutMarginsGuide.topAnchor
		rightRadioButton.touchArea.bottomAnchor == layoutMarginsGuide.bottomAnchor

		// Connect both button touch areas.
		leftRadioButton.touchArea.trailingAnchor == rightRadioButton.touchArea.leadingAnchor
		leftRadioButton.touchArea.widthAnchor == rightRadioButton.touchArea.widthAnchor

		// Center the content label in between of both radio buttons.
		contentLabel.topAnchor == layoutMarginsGuide.topAnchor
		contentLabel.bottomAnchor == layoutMarginsGuide.bottomAnchor
		contentLabel.leadingAnchor == leftRadioButton.trailingAnchor + Const.Size.defaultGap
		contentLabel.trailingAnchor == rightRadioButton.leadingAnchor - Const.Size.defaultGap
		contentLabel.heightAnchor >= Const.Size.cellDefaultLabelMinHeight ~ .high

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
		backgroundColor = Const.Color.white
		contentType = { contentType }()
		largeStyle = { largeStyle }()
		leftSelected = { leftSelected }()
		rightSelected = { rightSelected }()
	}

	// MARK: - Subviews

	/// The title label displaying the main content.
	private let contentLabel: UILabel = {
		let label = UILabel(frame: .max)
		label.textColor = Const.Color.darkMain
		label.lineBreakMode = .byClipping
		return label
	}()

	/// The left radio button.
	private let leftRadioButton: RadioButton = {
		let button = RadioButton()
		button.defaultColor = Const.Color.magenta
		button.selectColor = Const.Color.magenta
		return button
	}()

	/// The right radio button.
	private let rightRadioButton: RadioButton = {
		let button = RadioButton()
		button.defaultColor = Const.Color.lightMain
		button.selectColor = Const.Color.lightMain
		return button
	}()

	/// The separator at the bottom.
	private let separatorView: UIView = {
		let view = UIView(frame: .max)
		view.backgroundColor = Const.Color.darkMain
		return view
	}()

	/// The constraints used when the `largeStyle` property is `true`.
	private lazy var scaledConstraints: [NSLayoutConstraint] = {
		Anchorage.batch(active: false) {
			separatorView.heightAnchor == Const.Size.separatorThicknessLarge
			contentLabel.heightAnchor >= Const.Size.cellDefaultLabelMinHeight * Const.Size.landscapeScaleFactor
		}
	}()

	// MARK: - Properties

	/// The readingtest's magnitude which represents the content text, font and size.
	var contentType: ReadingTestMagnitudeType = .medium {
		didSet {
			let contentText = contentType.contentText()
			contentLabel.attributedText = contentText.styled(with: Const.StringStyle.base)
			contentLabel.numberOfLines = contentType.defaultLines()
			contentLabel.font = contentType.textFont()
		}
	}

	/// Whether the left radio button is selected.
	var leftSelected: Bool {
		get { return leftRadioButton.isSelected }
		set { leftRadioButton.isSelected = newValue }
	}

	/// Whether the right radio button is selected.
	var rightSelected: Bool {
		get { return rightRadioButton.isSelected }
		set { rightRadioButton.isSelected = newValue }
	}

	/// Whether the view uses a large style for labels and sub-views. Defaults to `false`.
	var largeStyle = false {
		didSet {
			// Apply style to subviews.
			leftRadioButton.largeStyle = largeStyle
			rightRadioButton.largeStyle = largeStyle

			// Apply constraints.
			if largeStyle {
				NSLayoutConstraint.activate(scaledConstraints)
			} else {
				NSLayoutConstraint.deactivate(scaledConstraints)
			}
		}
	}

	/// The delegate caller who informs about the left button press.
	private(set) lazy var onLeftButtonPressed: ControlCallback<ReadingTestMainCellView> = {
		ControlCallback(for: leftRadioButton, event: .touchUpInside) { [unowned self] in
			self
		}
	}()

	/// The delegate caller who informs about the right button press.
	private(set) lazy var onRightButtonPressed: ControlCallback<ReadingTestMainCellView> = {
		ControlCallback(for: rightRadioButton, event: .touchUpInside) { [unowned self] in
			self
		}
	}()

	// MARK: - Interface Builder

	@IBInspectable private lazy var ibContentType: Int = contentType.rawValue
	@IBInspectable private lazy var ibLeftSelected: Bool = leftSelected
	@IBInspectable private lazy var ibRightSelected: Bool = rightSelected
	@IBInspectable private lazy var ibLargeStyle: Bool = largeStyle

	override func prepareForInterfaceBuilder() {
		// For crashing reports look at '~/Library/Logs/DiagnosticReports/'.
		super.prepareForInterfaceBuilder()

		translatesAutoresizingMaskIntoConstraints = true
		backgroundColor = Const.Color.white

		contentType = ReadingTestMagnitudeType(rawValue: ibContentType) ?? contentType
		leftSelected = ibLeftSelected
		rightSelected = ibRightSelected
		largeStyle = ibLargeStyle
	}
}
