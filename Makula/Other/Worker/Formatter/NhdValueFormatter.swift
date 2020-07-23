import Foundation

/// The formatter for the NHD values.
class NhdValueFormatter: NumberFormatter {
	override init() {
		super.init()
		maximumFractionDigits = 0
		minimumIntegerDigits = 1
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
