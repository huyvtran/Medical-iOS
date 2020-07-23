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
class NoteView: UIView {
	// MARK: - Init

	/// A weak reference to the logic for informing about any user actions in this view.
	private weak var logic: NoteLogicInterface?

	/**
	 Initializes this view.

	 - parameter logic: The logic to inform about any user actions. Will not be retained.
	 */
	init(logic: NoteLogicInterface) {
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
		accessibilityIdentifier = Const.NoteTests.ViewName.mainView

		// Create view hierarchy.
		addSubview(navigationView)
		addSubview(contentView)

		// Position the navigation view at the top.
		navigationView.leadingAnchor == leadingAnchor
		navigationView.trailingAnchor == trailingAnchor
		navigationView.topAnchor == topAnchor

		// Position the content view between the navigation and the bottom.
		contentView.leadingAnchor == layoutMarginsGuide.leadingAnchor
		contentView.topAnchor == navigationView.bottomAnchor
		contentView.trailingAnchor == layoutMarginsGuide.trailingAnchor
		contentViewBottomConstraint = contentView.bottomAnchor == layoutMarginsGuide.bottomAnchor

		// Apply margins.
		if #available(iOS 11.0, *) {
			directionalLayoutMargins = Const.Margin.default.directional
		} else {
			layoutMargins = Const.Margin.default
		}

		// Set default styles.
		backgroundColor = Const.Color.white
		navigationViewHidden = { navigationViewHidden }()
		isContentEmpty = { isContentEmpty }()
		largeStyle = { largeStyle }()

		// Register for callback actions.
		navigationView.onLeftButtonPressed.setDelegate(to: self, with: { strongSelf, _ in
			strongSelf.logic?.backButtonPressed()
		})
		navigationView.onRightButtonPressed.setDelegate(to: self, with: { strongSelf, _ in
			strongSelf.logic?.speakButtonPressed()
		})
	}

	// MARK: - Subviews

	/// The navigation view at the top of the view.
	private let navigationView: NavigationView = {
		let view = NavigationView()
		view.title = R.string.note.title()
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
		textView.textColor = Const.Color.darkMain
		textView.textContainer.lineFragmentPadding = 0
		textView.returnKeyType = .done
		return textView
	}()

	// MARK: - Properties

	/// The content string for the scene.
	var contentText: String? {
		get { return contentView.text.trimmingCharacters(in: .whitespacesAndNewlines) }
		set { contentView.text = newValue }
	}

	/// The constraint to adjust the frame of the text view.
	var contentViewBottomConstraint: NSLayoutConstraint?

	/// Whether the content is empty or not. Defaults to `true`.
	var isContentEmpty = true {
		didSet {
			if isContentEmpty {
				contentView.textColor = Const.Color.gray
				contentView.text = R.string.note.placeholderText()
			} else {
				contentView.textColor = Const.Color.darkMain
			}
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

	/// The delegate to inform about actions in the input text field.
	var textViewDelegate: UITextViewDelegate? {
		get { return contentView.delegate }
		set { contentView.delegate = newValue }
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
			contentView.font = largeStyle ? Const.Font.content2Large : Const.Font.content2Default
		}
	}

	// MARK: - Interface Builder

	@IBInspectable private lazy var ibNavigationViewHidden: Bool = navigationViewHidden
	@IBInspectable private lazy var ibLargeStyle: Bool = largeStyle
	@IBInspectable private lazy var ibContent: String = "Content"

	override func prepareForInterfaceBuilder() {
		// For crashing reports look at '~/Library/Logs/DiagnosticReports/'.
		super.prepareForInterfaceBuilder()

		backgroundColor = Const.Color.white
		contentText = ibContent
		navigationViewHidden = ibNavigationViewHidden
		largeStyle = ibLargeStyle
	}
}
