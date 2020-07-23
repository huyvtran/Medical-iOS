import RealmSwift

/// A single entry of the amslertest.
@objcMembers class AmslertestModel: Object {
	// MARK: - Properties

	/// The date when this entry was measured.
	/// Make sure it's unique based on the day.
	dynamic var date: Date = Date()

	/// The persisted raw value for `progressLeft`.
	private let progressLeftValue = RealmOptional<Int>()

	/// The measured value for the left eye.
	var progressLeft: AmslertestProgressType? {
		get {
			if let value = progressLeftValue.value, let type = AmslertestProgressType(rawValue: value) {
				return type
			}
			return nil
		}
		set {
			progressLeftValue.value = newValue?.rawValue
		}
	}

	/// The persisted raw value for `progressRight`.
	private let progressRightValue = RealmOptional<Int>()

	/// The measured value for the right eye.
	var progressRight: AmslertestProgressType? {
		get {
			if let value = progressRightValue.value, let type = AmslertestProgressType(rawValue: value) {
				return type
			}
			return nil
		}
		set {
			progressRightValue.value = newValue?.rawValue
		}
	}

	// MARK: - Indexes

	override static func indexedProperties() -> [String] {
		return ["date"]
	}
}

/// The progress type for the amslertest.
@objc enum AmslertestProgressType: Int {
	/// Same progress, nothing has changed (`gleich`).
	case equal = 1
	/// The situation improved it got better (`besser`).
	case better
	/// The situation got worse (`schlechter`).
	case worse

	/**
	 Returns the localized text for this type.

	 - returns: The localized text.
	 */
	func titleText() -> String {
		switch self {
		case .equal:
			return R.string.global.amslertestProgressEqual()
		case .better:
			return R.string.global.amslertestProgressBetter()
		case .worse:
			return R.string.global.amslertestProgressWorse()
		}
	}

	/**
	 Returns the speech synthesizer text for this type.

	 - returns: The text for the speech synthesizer.
	 */
	func titleSpeechText() -> String {
		switch self {
		case .equal:
			return R.string.global.amslertestProgressEqualSpeech()
		case .better:
			return R.string.global.amslertestProgressBetterSpeech()
		case .worse:
			return R.string.global.amslertestProgressWorseSpeech()
		}
	}
}
