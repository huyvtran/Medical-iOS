/// The diagnosis table cell representations.
enum ContactDetailsTableData {
	/// The cell with a static title label.
	case contactTitle
	/// The main cell entry for a contact info type.
	case entry(ContactInfoType)
	/// The navigation view as a cell.
	case navigation

	/// The cell's accessibiliy identifier to assign to the cell depending of its type.
	var accessibilityIdentifier: String {
		switch self {
		case .contactTitle:
			return "ContactDetailsCellTitle"
		case .entry(.name):
			return "ContactDetailsCellNameEntry"
		case .entry(.mobile):
			return "ContactDetailsCellMobileEntry"
		case .entry(.phone):
			return "ContactDetailsCellPhoneEntry"
		case .entry(.email):
			return "ContactDetailsCellEmailEntry"
		case .entry(.web):
			return "ContactDetailsCellWebEntry"
		case .entry(.street):
			return "ContactDetailsCellStreetEntry"
		case .entry(.city):
			return "ContactDetailsCellCityEntry"
		case .navigation:
			return "ContactDetailsCellNavbar"
		}
	}
}
