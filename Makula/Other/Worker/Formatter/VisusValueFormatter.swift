import Foundation

/// The formatter for the Visus values.
class VisusValueFormatter: NumberFormatter {
	override init() {
		super.init()
		maximumFractionDigits = 2
		minimumFractionDigits = 2
		minimumIntegerDigits = 1
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func string(for obj: Any?) -> String? {
		guard let value = obj as? Int else { return nil }
		// The values provided are indexes to fixed values.
		let displayValue = VisusValueFormatter.mapValue(value)
		return super.string(for: displayValue)
	}

	/**
	 Maps a given internally represented Visus index value to the real world value which is displayed to the user.
	 So the value 0 is mapped to 0.02, 1 to 0.03 and so on up to 12 which is mapped to 1.0.

	 Values out of bounds are clamped.

	 - parameter value: The index value to map to the display value.
	 - returns: The real world display value.
	 */
	static func mapValue(_ value: Int) -> Double {
		switch value {
		case _ where value <= 0:
			return 0.02
		case 1:
			return 0.03
		case 2:
			return 0.05
		case 3:
			return 0.08
		case 4:
			return 0.1
		case 5:
			return 0.16
		case 6:
			return 0.2
		case 7:
			return 0.32
		case 8:
			return 0.4
		case 9:
			return 0.5
		case 10:
			return 0.63
		case 11:
			return 0.8
		case _ where value >= 12:
			return 1.0
		default:
			fatalError()
		}
	}
}
