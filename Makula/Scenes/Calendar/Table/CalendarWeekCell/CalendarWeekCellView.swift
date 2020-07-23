import Anchorage
import Timepiece
import UIKit

@IBDesignable
class CalendarWeekCellView: UIView {
	/// The calendar to use for date calculations.
	var calendar: () -> Calendar = {
		CommonDateFormatter.calendar
	}

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
		addSubview(stackView)
		addSubview(separatorView)

		// Embedd the stackview into this view spanning the whole space.
		stackView.edgeAnchors == layoutMarginsGuide.edgeAnchors

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
		date = { date }()
		resetDayLabels()
	}

	// MARK: - Subviews

	/// The stack view containing the week name labels.
	private lazy var stackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: dayLabels)
		stackView.axis = .horizontal
		stackView.distribution = .fillEqually
		return stackView
	}()

	/// The day labels in the stack view.
	private lazy var dayLabels: [UILabel] = [
		dayNameLabel(tag: 0),
		dayNameLabel(tag: 1),
		dayNameLabel(tag: 2),
		dayNameLabel(tag: 3),
		dayNameLabel(tag: 4),
		dayNameLabel(tag: 5),
		dayNameLabel(tag: 6)
	]

	/**
	 Creates a day name label for the stack view with an embedded button to tap on a day.

	 - parameter tag: The label's and button's tag representing the day's index.
	 - returns: A new label.
	 */
	private func dayNameLabel(tag: Int) -> UILabel {
		let label = UILabel()
		label.attributedText = String.empty.styled(with: Const.StringStyle.base)
		label.textAlignment = .center
		label.font = Const.Font.numbersDefault
		label.tag = tag
		label.isUserInteractionEnabled = true // Pass interactions to button.

		// Add button above label.
		let button = UIButton()
		button.tag = tag
		button.addTarget(self, action: #selector(dayLabelButtonPressed(_:)), for: .touchUpInside)
		label.addSubview(button)
		button.edgeAnchors == label.edgeAnchors

		return label
	}

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

	/// Whether the view uses a large style for labels and sub-views. Defaults to `false`.
	var largeStyle = false {
		didSet {
			// Apply font to the stack view labels.
			for label in dayLabels {
				label.font = largeStyle ? Const.Font.numbersLarge : Const.Font.numbersDefault
			}

			// Apply constraints.
			if largeStyle {
				NSLayoutConstraint.activate(scaledConstraints)
			} else {
				NSLayoutConstraint.deactivate(scaledConstraints)
			}
		}
	}

	/**
	 Resets the color of all day labels to their default color and clears their title text.
	 */
	func resetDayLabels() {
		for label in dayLabels {
			if label.tag >= 0 && label.tag <= 4 {
				// Monday ... Friday -> light blue color.
				label.textColor = Const.Color.lightMain
			} else {
				// Weekend -> gray color.
				label.textColor = Const.Color.gray
			}
			label.attributedText = String.empty.styled(with: Const.StringStyle.base)
		}
	}

	/**
	 Sets the color for a specific day label.

	 - parameter color: The color to set.
	 - parameter index: The label's index ranging from 0 to 6 with 0 = Monday and 6 = Sunday.
	 */
	func setDayLabelColor(_ color: UIColor, atIndex index: Int) {
		precondition(index >= 0 && index <= 6)

		let label = dayLabels[index]
		label.textColor = color
	}

	/**
	 Sets the title string for a specific day label.

	 - parameter title: The text to display.
	 - parameter index: The label's index ranging from 0 to 6 with 0 = Monday and 6 = Sunday.
	 */
	func setDayLabelTitle(_ title: String, atIndex index: Int) {
		precondition(index >= 0 && index <= 6)

		let label = dayLabels[index]
		label.attributedText = title.styled(with: Const.StringStyle.base)
	}

	/// The date this view represents and returns when pressing a day.
	var date = Date()

	/// The action for a day label button when pressed.
	@IBAction private func dayLabelButtonPressed(_ sender: UIButton) {
		onDayPressed.callback?(sender.tag)
	}

	/// The delegate caller who informs about presses on a day. Returns the day button's index / tag.
	let onDayPressed = DelegatedCall<Int>()

	// MARK: - Interface Builder

	@IBInspectable private lazy var ibLargeStyle: Bool = largeStyle
	@IBInspectable private var ibMonText: String?
	@IBInspectable private var ibMonColor: UIColor?
	@IBInspectable private var ibTueText: String?
	@IBInspectable private var ibTueColor: UIColor?
	@IBInspectable private var ibWedText: String?
	@IBInspectable private var ibWedColor: UIColor?
	@IBInspectable private var ibThuText: String?
	@IBInspectable private var ibThuColor: UIColor?
	@IBInspectable private var ibFriText: String?
	@IBInspectable private var ibFriColor: UIColor?
	@IBInspectable private var ibSatText: String?
	@IBInspectable private var ibSatColor: UIColor?
	@IBInspectable private var ibSunText: String?
	@IBInspectable private var ibSunColor: UIColor?

	override func prepareForInterfaceBuilder() {
		// For crashing reports look at '~/Library/Logs/DiagnosticReports/'.
		super.prepareForInterfaceBuilder()
		backgroundColor = Const.Color.darkMain

		translatesAutoresizingMaskIntoConstraints = true
		largeStyle = ibLargeStyle

		if let text = ibMonText {
			setDayLabelTitle(text, atIndex: 0)
		}
		if let color = ibMonColor {
			setDayLabelColor(color, atIndex: 0)
		}
		if let text = ibTueText {
			setDayLabelTitle(text, atIndex: 1)
		}
		if let color = ibTueColor {
			setDayLabelColor(color, atIndex: 1)
		}
		if let text = ibWedText {
			setDayLabelTitle(text, atIndex: 2)
		}
		if let color = ibWedColor {
			setDayLabelColor(color, atIndex: 2)
		}
		if let text = ibThuText {
			setDayLabelTitle(text, atIndex: 3)
		}
		if let color = ibThuColor {
			setDayLabelColor(color, atIndex: 3)
		}
		if let text = ibFriText {
			setDayLabelTitle(text, atIndex: 4)
		}
		if let color = ibFriColor {
			setDayLabelColor(color, atIndex: 4)
		}
		if let text = ibSatText {
			setDayLabelTitle(text, atIndex: 5)
		}
		if let color = ibSatColor {
			setDayLabelColor(color, atIndex: 5)
		}
		if let text = ibSunText {
			setDayLabelTitle(text, atIndex: 6)
		}
		if let color = ibSunColor {
			setDayLabelColor(color, atIndex: 6)
		}
	}
}
