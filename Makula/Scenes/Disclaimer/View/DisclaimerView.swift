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
class DisclaimerView: UIView {
	// MARK: - Init

	/// A weak reference to the logic for informing about any user actions in this view.
	private weak var logic: DisclaimerLogicInterface?

	/**
	 Initializes this view.

	 - parameter logic: The logic to inform about any user actions. Will not be retained.
	 */
	init(logic: DisclaimerLogicInterface) {
		self.logic = logic
		super.init(frame: .max)
		configureView()
	}

	@available(*, unavailable)
	override init(frame: CGRect) {
		// Needed for InterfaceBuilder.
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
		accessibilityIdentifier = Const.DisclaimerTests.ViewName.mainView

		// Create view hierarchy.
		addSubview(scrollView)
		addSubview(confirmButton)
		scrollView.addSubview(scrollContentView)

		// Place the confirm button at the bottom.
		confirmButton.leadingAnchor == leadingAnchor
		confirmButton.trailingAnchor == trailingAnchor
		confirmButton.bottomAnchor == bottomAnchor

		// Let the scroll view fill up the entire screen above the confirm button.
		scrollView.leadingAnchor == leadingAnchor
		scrollView.trailingAnchor == trailingAnchor
		scrollView.topAnchor == layoutMarginsGuide.topAnchor
		scrollView.bottomAnchor == confirmButton.topAnchor

		// Embed the content view inside of the scroll view.
		scrollContentView.leadingAnchor == scrollView.leadingAnchor
		scrollContentView.trailingAnchor == scrollView.trailingAnchor
		scrollContentView.topAnchor == scrollView.topAnchor
		scrollContentView.bottomAnchor == scrollView.bottomAnchor
		scrollContentView.widthAnchor == scrollView.widthAnchor

		// Set default styles.
		backgroundColor = Const.Color.darkMain
		confirmButtonEnabled = { confirmButtonEnabled }()
		largeStyle = { largeStyle }()

		// Register for callback actions.
		onConfirmButtonPressed.setDelegate(to: self, with: { strongSelf, _ in
			strongSelf.logic?.confirmButtonPressed()
		})
		scrollContentView.onCheckboxButtonPressed.setDelegate(to: self, with: { strongSelf, contentView in
			let newCheckedState = !contentView.checked
			contentView.checked = newCheckedState
			strongSelf.logic?.checkboxButtonStateChanged(checked: newCheckedState)
		})
	}

	// MARK: - Subviews

	/// The scroll view containing the content view.
	private let scrollView: UIScrollView = {
		let view = UIScrollView()
		view.accessibilityIdentifier = Const.DisclaimerTests.ViewName.scrollView
		return view
	}()

	/// The scroll view's content view containing the text and checkbox.
	private let scrollContentView: DisclaimerContentView = {
		let view = DisclaimerContentView()
		return view
	}()

	/// The confirm button at the bottom to navigate to next scene.
	private let confirmButton: ConfirmButton = {
		let button = ConfirmButton()
		button.accessibilityIdentifier = Const.DisclaimerTests.ViewName.confirmButton
		button.titleText = R.string.disclaimer.confirmButtonTitle()
		return button
	}()

	// MARK: - Properties

	/// Whether the confirm button is enabled or not. Defaults to `false`.
	var confirmButtonEnabled = false {
		didSet {
			confirmButton.isEnabled = confirmButtonEnabled
		}
	}

	/// Whether the view uses a large style for its content or not. Defaults to `false`.
	var largeStyle = false {
		didSet {
			scrollContentView.largeStyle = largeStyle
			confirmButton.largeStyle = largeStyle
		}
	}

	/// The delegate caller who informs about a confirm button press.
	private(set) lazy var onConfirmButtonPressed: ControlCallback<DisclaimerView> = {
		ControlCallback(for: confirmButton, event: .touchUpInside) { [unowned self] in
			self
		}
	}()

	// MARK: - Interface Builder

	@IBInspectable private lazy var ibConfirmButtonEnabled: Bool = confirmButtonEnabled
	@IBInspectable private lazy var ibLargeStyle: Bool = largeStyle

	override func prepareForInterfaceBuilder() {
		// For crashing reports look at '~/Library/Logs/DiagnosticReports/'.
		super.prepareForInterfaceBuilder()

		confirmButtonEnabled = ibConfirmButtonEnabled
		largeStyle = ibLargeStyle
	}
}
