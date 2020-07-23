import Anchorage
import UIKit

/**
 The content view of the disclaimer scene's scroll view.
 Shows the disclaimer text content and the checkbox to confirm it.
 */
@IBDesignable
class DisclaimerContentView: UIView {
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
		accessibilityIdentifier = Const.DisclaimerTests.ViewName.scrollContentView

		// Create view hierarchy.
		addSubview(titleLabel)
		addSubview(descriptionLabel)
		addSubview(checkboxLabel)
		addSubview(checkboxButton)

		// Place the title at the top.
		titleLabel.topAnchor == layoutMarginsGuide.topAnchor
		titleLabel.leadingAnchor == layoutMarginsGuide.leadingAnchor
		titleLabel.trailingAnchor == layoutMarginsGuide.trailingAnchor

		// Then the description text follows.
		descriptionLabel.topAnchor == titleLabel.bottomAnchor + Const.Disclaimer.Size.contentGap
		descriptionLabel.leadingAnchor == layoutMarginsGuide.leadingAnchor
		descriptionLabel.trailingAnchor == layoutMarginsGuide.trailingAnchor
		// Should the space be too small then the description text should be compressed.
		descriptionLabel.verticalCompressionResistance = .high - 1

		// The checkbox label follows at the bottom.
		checkboxLabel.topAnchor == descriptionLabel.bottomAnchor + Const.Disclaimer.Size.contentGap
		checkboxLabel.leadingAnchor == layoutMarginsGuide.leadingAnchor
		checkboxLabel.bottomAnchor <= layoutMarginsGuide.bottomAnchor

		// The checkbox button is on the same line with its label.
		checkboxButton.bottomAnchor == checkboxLabel.bottomAnchor + 9
		checkboxButton.leadingAnchor == checkboxLabel.trailingAnchor + Const.Size.defaultGap
		checkboxButton.trailingAnchor <= layoutMarginsGuide.trailingAnchor

		// Apply margins.
		if #available(iOS 11.0, *) {
			directionalLayoutMargins = Const.Disclaimer.Margin.content.directional
		} else {
			layoutMargins = Const.Disclaimer.Margin.content
		}

		// Set default styles.
		backgroundColor = Const.Color.darkMain
		checked = { checked }()
		largeStyle = { largeStyle }()
	}

	// MARK: - Subviews

	/// The content title.
	private let titleLabel: UILabel = {
		let label = UILabel(frame: .max)
		label.attributedText = R.string.disclaimer.title().styled(with: Const.StringStyle.base)
		label.textColor = Const.Color.white
		label.numberOfLines = 0
		return label
	}()

	/// The content text.
	private let descriptionLabel: UILabel = {
		let label = UILabel(frame: .max)
		label.attributedText = R.string.disclaimer.description().styled(with: Const.StringStyle.base)
		label.textColor = Const.Color.white
		label.numberOfLines = 0
		return label
	}()

	/// The label next to the checkbox button.
	private let checkboxLabel: UILabel = {
		let label = UILabel(frame: .max)
		label.attributedText = R.string.disclaimer.checkboxTitle().styled(with: Const.StringStyle.base)
		label.textColor = Const.Color.white
		label.numberOfLines = 1
		return label
	}()

	/// The checkbox to confirm the disclaimer.
	private let checkboxButton: CheckmarkButton = {
		let button = CheckmarkButton()
		button.accessibilityIdentifier = Const.DisclaimerTests.ViewName.checkbox
		return button
	}()

	// MARK: - Properties

	/// The state of checkbox. Defaults to `false`.
	var checked = false {
		didSet {
			checkboxButton.checked = checked
		}
	}

	/// Whether the view uses the large style for labels and the large the checkbox or not. Defaults to `false`.
	var largeStyle = false {
		didSet {
			titleLabel.font = largeStyle ? Const.Font.content1Large : Const.Font.content1Default
			descriptionLabel.font = largeStyle ? Const.Font.content1Large : Const.Font.content1Default
			checkboxLabel.font = largeStyle ? Const.Font.content1Large : Const.Font.content1Default
			checkboxButton.largeStyle = largeStyle
		}
	}

	/// The delegate caller who informs about a checkbox button press event.
	private(set) lazy var onCheckboxButtonPressed: ControlCallback<DisclaimerContentView> = {
		ControlCallback(for: checkboxButton, event: .touchUpInside) { [unowned self] in
			self
		}
	}()

	// MARK: - Interface Builder

	@IBInspectable private lazy var ibBgColor: UIColor = Const.Color.darkMain
	@IBInspectable private lazy var ibChecked: Bool = checked
	@IBInspectable private lazy var ibLargeStyle: Bool = largeStyle

	override func prepareForInterfaceBuilder() {
		// For crashing reports look at '~/Library/Logs/DiagnosticReports/'.
		super.prepareForInterfaceBuilder()

		backgroundColor = ibBgColor
		checked = ibChecked
		largeStyle = ibLargeStyle
	}
}
