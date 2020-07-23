import Anchorage
import UIKit

@IBDesignable
class CalendarMonthCellView: UIView {
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
		addSubview(separatorView)

		// Make the view fit the title label.
		titleLabel.edgeAnchors == layoutMarginsGuide.edgeAnchors
		titleLabel.heightAnchor >= Const.Size.cellDefaultLabelMinHeight

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

	/// The view's title label.
	private let titleLabel: UILabel = {
		let label = UILabel(frame: .max)
		label.numberOfLines = 1
		label.textColor = Const.Color.white
		return label
	}()

	/// The separator at the bottom.
	private let separatorView: UIView = {
		let view = UIView(frame: .max)
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

	/// The text of the title label.
	var title: String {
		get { return titleLabel.attributedText?.string ?? String.empty }
		set { titleLabel.attributedText = newValue.styled(with: Const.StringStyle.base) }
	}

	/// Whether the view uses a large style for labels and sub-views. Defaults to `false`.
	var largeStyle = false {
		didSet {
			titleLabel.font = largeStyle ? Const.Font.headline1Large : Const.Font.headline1Default

			// Apply constraints.
			if largeStyle {
				NSLayoutConstraint.activate(scaledConstraints)
			} else {
				NSLayoutConstraint.deactivate(scaledConstraints)
			}
		}
	}

	// MARK: - Interface Builder

	@IBInspectable private lazy var ibTitle: String = "Title"
	@IBInspectable private lazy var ibLargeStyle: Bool = largeStyle

	override func prepareForInterfaceBuilder() {
		// For crashing reports look at '~/Library/Logs/DiagnosticReports/'.
		super.prepareForInterfaceBuilder()
		backgroundColor = Const.Color.darkMain

		translatesAutoresizingMaskIntoConstraints = true
		title = ibTitle
		largeStyle = ibLargeStyle
	}
}
