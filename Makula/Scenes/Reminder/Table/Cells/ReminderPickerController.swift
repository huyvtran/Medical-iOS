import UIKit

class ReminderPickerController: NSObject {
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

	/// Whether the picker should show large text or not. Defaults to `false`.
	private var largeStyle = false

	/**
	 Sets the picker's value.

	 - parameter value: The time in minutes to show.
	 - parameter largeStyle: Whether the picker should be displayed in large mode or not.
	 */
	func setValue(_ value: Int, largeStyle: Bool) {
		self.largeStyle = largeStyle

		// Reload the picker.
		// Due to a bug in UIPickerView reload all components doesn't ask the delegate for the width as a workaround re-assign the delegate.
		picker.delegate = self
		picker.reloadAllComponents()
		selectedValue = value
	}

	/// The currently selected value which is the time in minutes.
	var selectedValue: Int {
		get {
			var value: Int = 0
			value += picker.selectedRow(inComponent: 0) * 60
			value += picker.selectedRow(inComponent: 1) * Const.Reminder.pickerMinuteInterval
			return value
		}
		set {
			setSelectedValue(newValue, animated: false)
		}
	}

	/**
	 Sets a value to show it in the picker.

	 - parameter newValue: The value to set in minutes.
	 - parameter animated: Whether to animate the picker columns.
	 */
	private func setSelectedValue(_ newValue: Int, animated: Bool) {
		let value = min(max(newValue, 0), (Const.Reminder.pickerMaxHours + 1) * 60)
		let firstDigit = value / 60
		picker.selectRow(firstDigit, inComponent: 0, animated: animated)
		let secondDigit = (value - firstDigit * 60) / Const.Reminder.pickerMinuteInterval
		picker.selectRow(secondDigit, inComponent: 1, animated: animated)
	}

	/// A delegate to register for value changes.
	let valueSelectedNotifier = DelegatedCall<Int>()
}

// MARK: - UIPickerViewDataSource

extension ReminderPickerController: UIPickerViewDataSource {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 2
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		switch component {
		case 0:
			return Const.Reminder.pickerMaxHours + 1
		default:
			return 60 / Const.Reminder.pickerMinuteInterval
		}
	}
}

// MARK: - UIPickerViewDelegate

extension ReminderPickerController: UIPickerViewDelegate {
	func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
		let valueString: String
		switch component {
		case 0:
			// Hours.
			valueString = R.string.reminder.pickerHourValue(row)
		case 1:
			// Minutes.
			valueString = R.string.reminder.pickerMinuteValue(row * Const.Reminder.pickerMinuteInterval)
		default:
			fatalError()
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
		// Inform delegate about value change.
		let value = selectedValue
		valueSelectedNotifier.callback?(value)
	}
}
