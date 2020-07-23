/// The diagnosis table cell representations.
enum DiagnosisTableCellType {
	/// The main cell with an entry to select.
	case main
	/// The navigation view as a cell.
	case navigation
}

/// All possible cells in the diagnosis with their accessibility identifier as key.
extension DiagnosisCellIdentifier {
	init?(_ diagnosisType: DiagnosisType) {
		switch diagnosisType {
		case .amd:
			self = .amd
		case .dmo:
			self = .dmo
		case .rvv:
			self = .rvv
		case .mcnv:
			self = .mcnv
		}
	}

	/**
	 Returns the speech text for the table cells.

	 - returns: The speech text.
	 */
	func speechText() -> String {
		switch self {
		case .amd:
			return R.string.diagnosis.cellTitleAmd()
		case .dmo:
			return R.string.diagnosis.cellTitleDmo()
		case .rvv:
			return R.string.diagnosis.cellTitleRvv()
		case .mcnv:
			return R.string.diagnosis.cellTitleMcnv()
		}
	}
}
