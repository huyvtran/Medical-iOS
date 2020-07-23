/// The reading test table cell representations.
enum ReadingTestTableData {
	/// The split view cell showing the left and right split.
	case split
	/// The main cell showing the text to read.
	case main(ReadingTestMagnitudeType)
	/// The navigation view as a cell.
	case navigation

	/// The cell's accessibiliy identifier to assign to the cell depending of its type.
	var accessibilityIdentifier: String {
		switch self {
		case .split:
			return "ReadingtestCellSplit"
		case .main(.big):
			return "ReadingtestCellMainBig"
		case .main(.large):
			return "ReadingtestCellMainLarge"
		case .main(.medium):
			return "ReadingtestCellMainMedium"
		case .main(.small):
			return "ReadingtestCellMainSmall"
		case .main(.little):
			return "ReadingtestCellMainLittle"
		case .main(.tiny):
			return "ReadingtestCellMainTiny"
		case .navigation:
			return "ReadingtestCellNavbar"
		}
	}
}
