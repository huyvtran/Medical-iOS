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
class AppointmentDatePickerView: UIView {
	// MARK: - Init

	/// A weak reference to the logic for informing about any user actions in this view.
	private weak var logic: AppointmentDatePickerLogicInterface?

	/**
	 Initializes this view.

	 - parameter logic: The logic to inform about any user actions. Will not be retained.
	 */
	init(logic: AppointmentDatePickerLogicInterface) {
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
		accessibilityIdentifier = Const.AppointmentDatePickerTests.ViewName.mainView

		// Create view hierarchy.
		addSubview(scrollView)
		addSubview(saveButton)
		scrollView.addSubview(scrollContentView)

		// Place the save button at the bottom.
		saveButton.leadingAnchor == leadingAnchor
		saveButton.trailingAnchor == trailingAnchor
		saveButton.bottomAnchor == bottomAnchor

		// Let the scroll view fill up the entire screen above the save button.
		scrollView.leadingAnchor == leadingAnchor
		scrollView.trailingAnchor == trailingAnchor
		scrollView.topAnchor == topAnchor
		scrollView.bottomAnchor == saveButton.topAnchor

		// Embed the content view inside of the scroll view.
		scrollContentView.edgeAnchors == scrollView.edgeAnchors
		scrollContentView.widthAnchor == scrollView.widthAnchor

		// Set default styles.
		backgroundColor = Const.Color.darkMain

		// Register for callback actions.
		scrollContentView.onLeftButtonPressedInNavigation.setDelegate(to: self, with: { strongSelf, _ in
			strongSelf.logic?.backButtonPressed()
		})
		onSaveButtonPressed.setDelegate(to: self, with: { strongSelf, _ in
			strongSelf.logic?.saveButtonPressed(withDate: strongSelf.scrollContentView.pickerDate)
		})
	}

	// MARK: - Subviews

	/// The scroll view.
	private let scrollView: UIScrollView = {
		let view = UIScrollView()
		view.accessibilityIdentifier = Const.AppointmentDatePickerTests.ViewName.scrollView
		view.backgroundColor = UIColor.clear
		view.isOpaque = false
		return view
	}()

	/// The scroll view's content view.
	private let scrollContentView: AppointmentDatePickerContentView = {
		let view = AppointmentDatePickerContentView()
		return view
	}()

	/// The save button at the bottom.
	private let saveButton: ConfirmButton = {
		let button = ConfirmButton()
		button.accessibilityIdentifier = Const.AppointmentDatePickerTests.ViewName.saveButton
		button.titleText = R.string.appointmentDatePicker.saveButtonTitle()
		button.arrowVisible = false
		return button
	}()

	// MARK: - Properties

	/// Whether the view uses a large style for sub-views. Defaults to `false`.
	var largeStyle = false {
		didSet {
			scrollContentView.largeStyle = largeStyle
			saveButton.largeStyle = largeStyle
		}
	}

	/// The current date shown by the date picker.
	var pickerDate: Date {
		get { return scrollContentView.pickerDate }
		set { scrollContentView.pickerDate = newValue }
	}

	/// The delegate caller who informs about a save button press.
	private(set) lazy var onSaveButtonPressed: ControlCallback<AppointmentDatePickerView> = {
		ControlCallback(for: saveButton, event: .touchUpInside) { [unowned self] in
			self
		}
	}()

	// MARK: - Interface Builder

	@IBInspectable private lazy var ibLarge: Bool = largeStyle

	override func prepareForInterfaceBuilder() {
		// For crashing reports look at '~/Library/Logs/DiagnosticReports/'.
		super.prepareForInterfaceBuilder()

		backgroundColor = Const.Color.darkMain
		largeStyle = ibLarge
	}
}
