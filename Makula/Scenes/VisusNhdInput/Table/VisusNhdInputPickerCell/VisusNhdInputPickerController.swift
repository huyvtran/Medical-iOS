import UIKit

class VisusNhdInputPickerController: NSObject {
	// MARK: - Init

	/// A reference to the picker this controller manages.
	private let picker: UIPickerView

	/**
	 Initializes the controller for a given picker.

	 - parameter picker: The picker this controller should manage. Keeps a strong reference to it.
	 */
	init(picker: UIPickerView) {
		self.picker = picker
		super.init()

		picker.dataSource = self
		picker.delegate = self
	}

	// MARK: - Interface

	/// The type this picker's values should reflect.
	private var type: VisusNhdType = .visus

	/// Whether the picker should show large text or not. Defaults to `false`.
	private var largeStyle = false

	/**
	 Sets the picker's value type and the value to show.

	 - parameter type: The picker's type.
	 - parameter value: The value to show.
	 - parameter largeStyle: Whether the picker should be displayed in large mode or not.
	 */
	func setType(_ type: VisusNhdType, value: Float, largeStyle: Bool) {
		self.type = type
		self.largeStyle = largeStyle

		// Reload the picker.
		// Due to a bug in UIPickerView reload all components doesn't ask the delegate for the width as a workaround re-assign the delegate.
		picker.delegate = self
		picker.reloadAllComponents()
		selectedValue = value
	}

	/// The currently selected value for the picker type shown in the picker (or at least close to it).
	var selectedValue: Float {
		get {
			switch type {
			case .visus:
				let index = picker.selectedRow(inComponent: 0)
				let value = Const.Data.visusMaxValue - Const.Data.visusMinValue - index
				return Float(value)
			case .nhd:
				var value: Float = 0
				value += Float(picker.selectedRow(inComponent: 0) * 100) + 200
				value += Float(picker.selectedRow(inComponent: 1) * 10)
				value += Float(picker.selectedRow(inComponent: 2))
				return value
			}
		}
		set {
			setSelectedValue(newValue, animated: false)
		}
	}

	/**
	 Sets a value to show it in the picker.

	 - parameter newValue: The value to set.
	 - parameter animated: Whether to animate the picker columns.
	 */
	private func setSelectedValue(_ newValue: Float, animated: Bool) {
		let value = min(max(newValue, type.minValue), type.maxValue)
		switch type {
		case .visus:
			let index = Const.Data.visusMaxValue - Const.Data.visusMinValue - Int(value)
			picker.selectRow(index, inComponent: 0, animated: animated)
		case .nhd:
			let firstDigit = Int(value) / 100
			picker.selectRow(firstDigit - 2, inComponent: 0, animated: animated)
			let secondDigit = (Int(value) - firstDigit * 100) / 10
			picker.selectRow(secondDigit, inComponent: 1, animated: animated)
			let thirdDigit = Int(value) - firstDigit * 100 - secondDigit * 10
			picker.selectRow(thirdDigit, inComponent: 2, animated: animated)
		}
	}

	/// A delegate to register for value changes.
	let valueSelectedNotifier = DelegatedCall<Float>()
}

// MARK: - UIPickerViewDataSource

extension VisusNhdInputPickerController: UIPickerViewDataSource {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		switch type {
		case .visus:
			return 1
		case .nhd:
			return 3
		}
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		switch type {
		case .visus:
			return Const.Data.visusMaxValue - Const.Data.visusMinValue + 1
		case .nhd:
			switch component {
			case 0:
				return 3 // 2 .. 4
			default:
				return 10 // 0 .. 9
			}
		}
	}
}

// MARK: - UIPickerViewDelegate

extension VisusNhdInputPickerController: UIPickerViewDelegate {
	func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
		let valueString: String
		switch type {
		case .visus:
			let value = Const.Data.visusMaxValue - Const.Data.visusMinValue - row
			let visusFormatter = VisusValueFormatter()
			valueString = visusFormatter.string(for: value) ?? String.empty
		case .nhd:
			switch component {
			case 0:
				// 2..4
				valueString = String(row + 2)
			default:
				// 0..9
				valueString = String(row)
			}
		}

		// Create label.
		let label = UILabel()
		label.attributedText = valueString.styled(with: Const.StringStyle.base)
		label.font = largeStyle ? Const.Font.headline1Large : Const.Font.headline1Default
		label.textColor = Const.Color.white
		label.textAlignment = .center
		return label
	}

	func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
		return largeStyle ? Const.Font.headline1Large.lineHeight : Const.Font.headline1Default.lineHeight
	}

	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		// Crop the value to fit into bounds.
		let value = selectedValue
		let valueInRange = min(max(value, type.minValue), type.maxValue)
		if valueInRange != value {
			setSelectedValue(valueInRange, animated: true)
		}

		// Inform delegate about value change.
		valueSelectedNotifier.callback?(valueInRange)
	}
}
