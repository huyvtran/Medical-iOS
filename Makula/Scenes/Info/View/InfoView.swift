import Anchorage
import UIKit

/**
 The scene controller's root view.

 This will be created in the controller's `loadView` method and creates the view with code instead of using Xibs and Storyboards.
 The root view is responsible for creating the view hierarchy and holds all subview references so that the display can access them.
 The view also forwards any user actions from controls to the logic.
 And the view might also provide additional code for displaying certain view states,
 but the view does NOT perform any logic nor formatting.
 */
@IBDesignable
class InfoView: UIView {
	// MARK: - Init

	/// A weak reference to the logic for informing about any user actions in this view.
	private weak var logic: InfoLogicInterface?

	/**
	 Initializes this view.

	 - parameter logic: The logic to inform about any user actions. Will not be retained.
	 */
	init(logic: InfoLogicInterface) {
		self.logic = logic
		super.init(frame: .max)
		configureView()
	}

	@available(*, unavailable)
	override init(frame: CGRect) {
		// Needed for InterfaceBuilder
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
		accessibilityIdentifier = Const.InfoTests.ViewName.mainView

		// Create view hierarchy.
		addSubview(navigationView)
		addSubview(contentView)
		addSubview(bottomButton)

		// Position the navigation view at the top.
		navigationView.leadingAnchor == leadingAnchor
		navigationView.trailingAnchor == trailingAnchor
		navigationView.topAnchor == topAnchor

		contentView.leadingAnchor == layoutMarginsGuide.leadingAnchor
		contentView.topAnchor == navigationView.bottomAnchor
		contentView.trailingAnchor == layoutMarginsGuide.trailingAnchor
		contentView.bottomAnchor == bottomButton.topAnchor

		bottomButton.leadingAnchor == leadingAnchor
		bottomButton.trailingAnchor == trailingAnchor
		bottomButton.bottomAnchor == bottomAnchor
		bottomButton.verticalCompressionResistance = .high + 1

		// Apply margins.
		if #available(iOS 11.0, *) {
			directionalLayoutMargins = Const.Margin.default.directional
		} else {
			layoutMargins = Const.Margin.default
		}

		// Set default styles.
		backgroundColor = Const.Color.lightMain
		largeStyle = { largeStyle }()
		navigationViewHidden = { navigationViewHidden }()
		bottomButtonVisible = { bottomButtonVisible }()

		// Register for callback actions.
		navigationView.onLeftButtonPressed.setDelegate(to: self, with: { strongSelf, _ in
			strongSelf.logic?.backButtonPressed()
		})
		navigationView.onRightButtonPressed.setDelegate(to: self, with: { strongSelf, _ in
			strongSelf.logic?.speakButtonPressed()
		})
		onBottomButtonPressed.setDelegate(to: self, with: { strongSelf, _ in
			strongSelf.logic?.bottomButtonPressed()
		})
	}

	// MARK: - Subviews

	/// The navigation view at the top of the view.
	private let navigationView: NavigationView = {
		let view = NavigationView()
		view.leftButtonType = .back
		view.leftButtonVisible = true
		view.rightButtonType = .speaker
		view.rightButtonVisible = true
		view.separatorVisible = false
		return view
	}()

	/// The constraint to activate for hiding the navigation view.
	private lazy var navigationViewHeightConstraint: NSLayoutConstraint = {
		navigationView.heightAnchor == 0
	}()

	/// The text view to show content.
	private let contentView: UITextView = {
		let textView = UITextView()
		textView.backgroundColor = UIColor.clear
		textView.showsVerticalScrollIndicator = false
		textView.showsHorizontalScrollIndicator = false
		textView.textContainer.lineFragmentPadding = 0
		textView.isEditable = false
		textView.dataDetectorTypes = .link
		textView.linkTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([
			// Overwrite the link attribute to force using the attributed strings style.
			NSAttributedString.Key.link.rawValue: UIColor.white
		])
		return textView
	}()

	private let bottomButton: TextButton = {
		let button = TextButton()
		button.backgroundColor = Const.Color.darkMain
		button.defaultColor = Const.Color.lightMain
		button.highlightColor = Const.Color.white
		button.titleTextAlignment = .center
		button.commonMargin = true
		return button
	}()

	/// The constraint to activate for hiding the bottom button.
	private lazy var bottomButtonHeightConstraint: NSLayoutConstraint = {
		bottomButton.heightAnchor == 0
	}()

	// MARK: - Properties

	/// The title string in the navigation view.
	var navigationViewTitle: String {
		get { return navigationView.title }
		set { navigationView.title = newValue }
	}

	/// The content string for the scene.
	var contentText: String = String.empty {
		didSet {
			contentView.attributedText = contentText.set(style: largeStyle ? InfoTextStyle.Large.group : InfoTextStyle.Default.group)
		}
	}

	/// The title of the bottom button.
	var bottomButtonText: String {
		get { return bottomButton.title }
		set { bottomButton.title = newValue }
	}

	/// The bottom button's visibility.
	var bottomButtonVisible = false {
		didSet {
			bottomButton.isHidden = !bottomButtonVisible
			bottomButtonHeightConstraint.isActive = !bottomButtonVisible
		}
	}

	/**
	 Sets the content offset to zero so the text should be on top.
	 */
	func bringContentToTop() {
		DispatchQueue.main.asyncAfter(deadline: .now()) {
			self.contentView.contentOffset = .zero
		}
	}

	/// Set to `false` (default) to show the navigation bar as part of the view at the top.
	/// Set to `true` to hide it and make the table view full screen.
	var navigationViewHidden = false {
		didSet {
			navigationView.isHidden = navigationViewHidden
			navigationViewHeightConstraint.isActive = navigationViewHidden
		}
	}

	/// Whether the view uses a large style for sub-views. Defaults to `false`.
	var largeStyle = false {
		didSet {
			navigationView.largeStyle = largeStyle
			bottomButton.largeStyle = largeStyle
			if largeStyle {
				contentView.attributedText = contentText.set(style: InfoTextStyle.Large.group)
			} else {
				contentView.attributedText = contentText.set(style: InfoTextStyle.Default.group)
			}
		}
	}

	/// The delegate caller who informs about a bottom button press.
	private(set) lazy var onBottomButtonPressed: ControlCallback<InfoView> = {
		ControlCallback(for: bottomButton, event: .touchUpInside) { [unowned self] in
			self
		}
	}()

	// MARK: - Interface Builder

	@IBInspectable private lazy var ibNavHidden: Bool = navigationViewHidden
	@IBInspectable private lazy var ibLargeStyle: Bool = largeStyle
	@IBInspectable private lazy var ibButtonText: String = "Bottom Button"
	@IBInspectable private lazy var ibButtonVisible: Bool = false

	override func prepareForInterfaceBuilder() {
		// For crashing reports look at '~/Library/Logs/DiagnosticReports/'.
		super.prepareForInterfaceBuilder()
		backgroundColor = Const.Color.lightMain
		navigationViewTitle = InfoType.amd.titleString()
		contentText = InfoType.amd.contentString()

		bottomButtonVisible = ibButtonVisible
		bottomButtonText = ibButtonText
		navigationViewHidden = ibNavHidden
		largeStyle = ibLargeStyle
	}
}

// Helper function inserted by Swift 4.2 migrator.
private func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value) })
}
