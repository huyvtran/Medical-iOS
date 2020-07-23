import Anchorage
import UIKit

@IBDesignable
class ReminderPickerCellView: UIView {
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
		addSubview(picker)

		// The picker takes the whole place.
		picker.edgeAnchors == layoutMarginsGuide.edgeAnchors

		// Apply margins.
		if #available(iOS 11.0, *) {
			directionalLayoutMargins = Const.Margin.default.directional
		} else {
			layoutMargins = Const.Margin.default
		}

		// Set default styles.
		backgroundColor = Const.Color.darkMain
	}

	// MARK: - Subviews

	/// The picker for choosing a value.
	private let picker: UIPickerView = {
		let picker = UIPickerView()
		return picker
	}()

	/// The controller for the picker.
	private lazy var pickerController: ReminderPickerController = {
		let controller = ReminderPickerController(picker: picker)
		return controller
	}()

	// MARK: - Properties

	/**
	 Sets the picker's value.

	 - parameter value: The value in minutes to show.
	 - parameter largeStyle: Whether a large style should be applied or not.
	 */
	func setValue(_ value: Int, largeStyle: Bool) {
		pickerController.setValue(value, largeStyle: largeStyle)
	}

	/// The current value the picker shows.
	var value: Int {
		get { return pickerController.selectedValue }
		set { pickerController.selectedValue = newValue }
	}

	/// A delegate to register for value changes in the picker.
	var valueChangedNotifier: DelegatedCall<Int> { return pickerController.valueSelectedNotifier }

	// MARK: - Interface Builder

	@IBInspectable private lazy var ibValue: Int = 20
	@IBInspectable private lazy var ibLarge: Bool = false

	override func prepareForInterfaceBuilder() {
		// For crashing reports look at '~/Library/Logs/DiagnosticReports/'.
		super.prepareForInterfaceBuilder()

		translatesAutoresizingMaskIntoConstraints = true
		backgroundColor = Const.Color.darkMain

		setValue(ibValue, largeStyle: ibLarge)
	}
}
