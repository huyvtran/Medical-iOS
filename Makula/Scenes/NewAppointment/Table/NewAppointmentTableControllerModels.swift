/// The table controller model of an entry.
struct NewAppointmentTableControllerRawEntry {
	/// The cell's type.
	let type: AppointmentType
}

/// The diagnosis table cell representations.
enum NewAppointmentTableData {
	/// The cell's model to display the main cell and the corresponding cell ID.
	case main(StaticTextCellModel, AppointmentCellIdentifier)
	/// The model for the navigation view as a cell.
	case navigation(NavigationViewCellModel)
}

/// All possible cells in the new appointment scene with their accessibility identifier as key.
enum AppointmentCellIdentifier: String {
	/// The treatment appointment cell.
	case treatment = "AppointmentCellTreatment"
	/// The aftercare appointment cell.
	case aftercare = "AppointmentCellAftercare"
	/// The OCT-check appointment cell.
	case octCheck = "AppointmentCellOctCheck"
	/// The other appointment cell.
	case other = "AppointmentCellOther"

	init?(appointmentType: AppointmentType) {
		switch appointmentType {
		case .treatment:
			self = .treatment
		case .aftercare:
			self = .aftercare
		case .octCheck:
			self = .octCheck
		case .other:
			self = .other
		}
	}

	/**
	 Returns the speech text for the table cells.

	 - returns: The speech text.
	 */
	func speechText() -> String {
		switch self {
		case .treatment:
			return AppointmentType.treatment.nameSpeechString()
		case .aftercare:
			return AppointmentType.aftercare.nameSpeechString()
		case .octCheck:
			return AppointmentType.octCheck.nameSpeechString()
		case .other:
			return AppointmentType.other.nameSpeechString()
		}
	}
}
