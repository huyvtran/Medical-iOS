import Anchorage
import BonMot
import UIKit

@IBDesignable
class DiagnosisMainCellView: UIView {
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
		addSubview(subtitleLabel)
		addSubview(radioButton)
		addSubview(infoButton)
		addSubview(separatorView)

		// Make the view fit the title label.
		titleLabel.leadingAnchor == layoutMarginsGuide.leadingAnchor
		titleLabel.trailingAnchor == layoutMarginsGuide.trailingAnchor
		titleLabel.topAnchor == layoutMarginsGuide.topAnchor
		titleLabel.bottomAnchor == subtitleLabel.topAnchor
		titleLabel.verticalCompressionResistance = .high - 1
		titleLabel.verticalHuggingPriority = .low - 1
		titleLabel.heightAnchor >= Const.Size.cellDefaultLabelMinHeight

		// The sub-title is inbetween of the radio and info button under the title.
		subtitleLabel.leadingAnchor == radioButton.trailingAnchor + Const.Size.defaultGap
		subtitleLabel.trailingAnchor == infoButton.leadingAnchor + Const.Size.defaultGap
		subtitleLabel.bottomAnchor == layoutMarginsGuide.bottomAnchor
		subtitleLabel.horizontalCompressionResistance = .high - 1
		subtitleLabel.horizontalHuggingPriority = .low - 1
		subtitleLabel.heightAnchor >= Const.Size.cellDefaultLabelMinHeight

		// The radio button goes to the bottom left.
		radioButton.centerYAnchor == subtitleLabel.centerYAnchor
		radioButton.leadingAnchor == layoutMarginsGuide.leadingAnchor

		// The info button goes to the bottom right.
		infoButton.centerYAnchor == subtitleLabel.centerYAnchor
		infoButton.trailingAnchor == layoutMarginsGuide.trailingAnchor

		// Add the separator to the bottom.
		separatorView.leadingAnchor == layoutMarginsGuide.leadingAnchor
		separatorView.trailingAnchor == layoutMarginsGuide.trailingAnchor
		separatorView.bottomAnchor == bottomAnchor
		// A height constraint which can break for the even thicker line constraint when in large mode.
		separatorView.heightAnchor == Const.Size.separatorThicknessNormal ~ .high

		// Apply margins.
		if #available(iOS 11.0, *) {
			directionalLayoutMargins = Const.Diagnosis.Margin.cell.directional
		} else {
			layoutMargins = Const.Diagnosis.Margin.cell
		}

		// Set default styles.
		applyDefaultColor()
		largeStyle = { largeStyle }()
	}

	// MARK: - Subviews

	/// The view's title label.
	private let titleLabel: UILabel = {
		let label = UILabel(frame: .max)
		label.numberOfLines = 0
		label.textColor = Const.Color.lightMain
		return label
	}()

	/// The view's subtitle label.
	private let subtitleLabel: UILabel = {
		let label = UILabel(frame: .max)
		label.textColor = Const.Color.lightMain
		return label
	}()

	/// The separator at the bottom.
	private let separatorView: UIView = {
		let view = UIView(frame: .max)
		return view
	}()

	/// The radio button at the bottom-left.
	private let radioButton: RadioButton = {
		let button = RadioButton()
		// Disabled because oherwise the cell won't receive the touch, but this button.
		button.isEnabled = false
		return button
	}()

	/// The info button at the bottom-right.
	private let infoButton: ImageButton = {
		let button = ImageButton(type: .info)
		return button
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

	/// The text of the subtitle label.
	var subtitle: String {
		get { return subtitleLabel.attributedText?.string ?? String.empty }
		set { subtitleLabel.attributedText = newValue.styled(with: Const.StringStyle.base) }
	}

	/// Whether the view uses a large font for labels or not. Defaults to `false`.
	var largeStyle = false {
		didSet {
			radioButton.largeStyle = largeStyle
			infoButton.largeStyle = largeStyle
			titleLabel.font = largeStyle ? Const.Font.headline1Large : Const.Font.headline1Default
			subtitleLabel.font = largeStyle ? Const.Font.headline1Large : Const.Font.headline1Default

			// Apply constraints.
			if largeStyle {
				NSLayoutConstraint.activate(scaledConstraints)
			} else {
				NSLayoutConstraint.deactivate(scaledConstraints)
			}
		}
	}

	/// The delegate caller who informs about a confirm button press.
	private(set) lazy var onInfoButtonPressed: ControlCallback<DiagnosisMainCellView> = {
		ControlCallback(for: infoButton, event: .touchUpInside) { [unowned self] in
			self
		}
	}()

	// MARK: - Colorizing

	/// Whether the cell is selected or not. `true` to select, `false` to deselect.
	private var isHighlighted = false

	/// Whether the title string is highlighted or not in speech mode. `true` to highlight, `false` to de-highlight.
	/// The selected state of the cell should NOT be changed.
	var isSpeechHighlighted = false {
		didSet {
			let titleColor = isHighlighted ? Const.Color.magenta : Const.Color.lightMain
			titleLabel.textColor = isSpeechHighlighted ? Const.Color.white : titleColor
		}
	}

	/**
	 Sets the color of the views depending on the current style state.
	 */
	func applyDefaultColor() {
		isHighlighted = false
		backgroundColor = Const.Color.darkMain
		separatorView.backgroundColor = Const.Color.lightMain
		titleLabel.textColor = Const.Color.lightMain
		subtitleLabel.textColor = Const.Color.lightMain
		radioButton.isSelected = false
	}

	/**
	 Sets the color of views for the hightlight / selected state.
	 */
	func applyHighlightColor() {
		isHighlighted = true
		backgroundColor = Const.Color.darkMain
		separatorView.backgroundColor = Const.Color.lightMain
		titleLabel.textColor = Const.Color.magenta
		subtitleLabel.textColor = Const.Color.magenta
		radioButton.isSelected = true
	}

	// MARK: - Interface Builder

	@IBInspectable private lazy var ibTitle: String = "Title"
	@IBInspectable private lazy var ibSubtitle: String = "(Sub)"
	@IBInspectable private lazy var ibLargeStyle: Bool = false
	@IBInspectable private lazy var ibHighlight: Bool = false
	@IBInspectable private lazy var ibSpeechHighlighted: Bool = isSpeechHighlighted

	override func prepareForInterfaceBuilder() {
		// For crashing reports look at '~/Library/Logs/DiagnosticReports/'.
		super.prepareForInterfaceBuilder()

		translatesAutoresizingMaskIntoConstraints = true
		backgroundColor = Const.Color.darkMain
		title = ibTitle
		subtitle = ibSubtitle
		largeStyle = ibLargeStyle
		isSpeechHighlighted = ibSpeechHighlighted

		if ibHighlight {
			applyHighlightColor()
		} else {
			applyDefaultColor()
		}
	}
}
