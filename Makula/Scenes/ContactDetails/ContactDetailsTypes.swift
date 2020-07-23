import Foundation

// Any global types for this scene.

/// The contact information type.
@objc enum ContactInfoType: Int {
	/// The contact name.
	case name = 1
	/// The contact mobile number.
	case mobile
	/// The contact phone number.
	case phone
	/// The contact email.
	case email
	/// The web address.
	case web
	/// The street of the contact person.
	case street
	/// The city of the contact person.
	case city

	/**
	 Returns the placeholder text for the this type.

	 - returns: The placeholder text.
	 */
	func defaultString() -> String {
		switch self {
		case .name:
			return R.string.contactDetails.nameCellTitle()
		case .mobile:
			return R.string.contactDetails.mobileCellTitle()
		case .phone:
			return R.string.contactDetails.phoneCellTitle()
		case .email:
			return R.string.contactDetails.emailCellTitle()
		case .web:
			return R.string.contactDetails.webCellTitle()
		case .street:
			return R.string.contactDetails.streetCellTitle()
		case .city:
			return R.string.contactDetails.cityCellTitle()
		}
	}

	/**
	 Returns the text for the this type to speak via a speech synthesizer.

	 - returns: The speech text.
	 */
	func speechString() -> String {
		switch self {
		case .name:
			return R.string.contactDetails.nameCellTitleSpeech()
		case .mobile:
			return R.string.contactDetails.mobileCellTitleSpeech()
		case .phone:
			return R.string.contactDetails.phoneCellTitleSpeech()
		case .email:
			return R.string.contactDetails.emailCellTitleSpeech()
		case .web:
			return R.string.contactDetails.webCellTitleSpeech()
		case .street:
			return R.string.contactDetails.streetCellTitleSpeech()
		case .city:
			return R.string.contactDetails.cityCellTitleSpeech()
		}
	}
}
