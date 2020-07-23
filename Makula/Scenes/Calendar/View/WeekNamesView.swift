import Anchorage
import UIKit

@IBDesignable
class WeekNamesView: UIView {
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
		accessibilityIdentifier = Const.CalendarTests.ViewName.weekNamesView

		// Create view hierarchy.
		addSubview(stackView)
		addSubview(separatorView)

		// Embedd the stackview into this view spanning the whole space.
		stackView.edgeAnchors == layoutMarginsGuide.edgeAnchors

		// Add the separator at the bottom.
		separatorView.leadingAnchor == layoutMarginsGuide.leadingAnchor
		separatorView.trailingAnchor == layoutMarginsGuide.trailingAnchor
		separatorView.bottomAnchor == bottomAnchor
		// A heigh constraint which can break for the even thicker line constraint when in large mode.
		separatorView.heightAnchor == Const.Size.separatorThicknessNormal ~ .high

		// Apply margins.
		if #available(iOS 11.0, *) {
			directionalLayoutMargins = Const.Calendar.Margin.weekNamesView.directional
		} else {
			layoutMargins = Const.Calendar.Margin.weekNamesView
		}

		// Set default styles.
		backgroundColor = Const.Color.darkMain
		largeStyle = { largeStyle }()
	}

	// MARK: - Subviews

	/// The stack view containing the week name labels.
	private let stackView: UIStackView = {
		var labels: [UILabel] = [
			weekNameLabel(title: R.string.calendar.weekNameMonday(), color: Const.Color.lightMain),
			weekNameLabel(title: R.string.calendar.weekNameTuesday(), color: Const.Color.lightMain),
			weekNameLabel(title: R.string.calendar.weekNameWednesday(), color: Const.Color.lightMain),
			weekNameLabel(title: R.string.calendar.weekNameThursday(), color: Const.Color.lightMain),
			weekNameLabel(title: R.string.calendar.weekNameFriday(), color: Const.Color.lightMain),
			weekNameLabel(title: R.string.calendar.weekNameSaturday(), color: Const.Color.gray),
			weekNameLabel(title: R.string.calendar.weekNameSunday(), color: Const.Color.gray)
		]
		let stackView = UIStackView(arrangedSubviews: labels)
		stackView.axis = .horizontal
		stackView.distribution = .fillEqually
		return stackView
	}()

	/**
	 Creates the week name labels for the stack view.

	 - parameter title: The label's title.
	 - parameter color: The text color.
	 - returns: A new label.
	 */
	private static func weekNameLabel(title: String, color: UIColor) -> UILabel {
		let label = UILabel()
		label.attributedText = title.styled(with: Const.StringStyle.base)
		label.textColor = color
		label.textAlignment = .center
		label.font = Const.Font.content2Default
		return label
	}

	/// The separator line at the bottom of the view.
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

	/// Whether the view uses a large font for labels and a scaled version for the icons or not. Defaults to `false`.
	var largeStyle = false {
		didSet {
			// Apply font to the stack view labels.
			for subview in stackView.arrangedSubviews {
				if let label = subview as? UILabel {
					label.font = largeStyle ? Const.Font.content2Large : Const.Font.content2Default
				}
			}

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
	@IBInspectable private lazy var ibLargeStyle: Bool = largeStyle

	override func prepareForInterfaceBuilder() {
		// For crashing reports look at '~/Library/Logs/DiagnosticReports/'.
		super.prepareForInterfaceBuilder()
		translatesAutoresizingMaskIntoConstraints = true

		backgroundColor = ibBgColor
		largeStyle = ibLargeStyle
	}
}
