import Anchorage
import UIKit

@IBDesignable
class VisusNhdInputPickerCellView: UIView {
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
	private lazy var pickerController: VisusNhdInputPickerController = {
		let controller = VisusNhdInputPickerController(picker: picker)
		return controller
	}()

	// MARK: - Properties

	/**
	 Sets the picker's value type and the value to show.

	 - parameter type: The picker's type.
	 - parameter value: The value to show.
	 - parameter largeStyle: Whether a large style should be applied or not.
	 */
	func setType(_ type: VisusNhdType, value: Float, largeStyle: Bool) {
		pickerController.setType(type, value: value, largeStyle: largeStyle)
	}

	/// The current value the picker shows.
	var value: Float {
		get { return pickerController.selectedValue }
		set { pickerController.selectedValue = newValue }
	}

	/// A delegate to register for value changes in the picker.
	var valueChangedNotifier: DelegatedCall<Float> { return pickerController.valueSelectedNotifier }

	// MARK: - Interface Builder

	@IBInspectable private lazy var ibType: Int = 0
	@IBInspectable private lazy var ibValue: Double = 1.0
	@IBInspectable private lazy var ibLarge: Bool = false

	override func prepareForInterfaceBuilder() {
		// For crashing reports look at '~/Library/Logs/DiagnosticReports/'.
		super.prepareForInterfaceBuilder()

		translatesAutoresizingMaskIntoConstraints = true
		backgroundColor = Const.Color.darkMain

		let type: VisusNhdType
		switch ibType {
		case 1:
			type = .nhd
		default:
			type = .visus
		}
		setType(type, value: Float(ibValue), largeStyle: ibLarge)
	}
}
