/// The amslertest table cell representations.
enum AmslertestTableData {
	/// The cell with a static grid image.
	case gridImage
	/// The cell with a static title label.
	case titleLabel
	/// The split view cell showing left and right.
	case split
	/// The split radio cell for a progress type.
	case splitRadio(AmslertestProgressType)
	/// The navigation view as a cell.
	case navigation

	/// The cell's accessibiliy identifier to assign to the cell depending of its type.
	var accessibilityIdentifier: String {
		switch self {
		case .gridImage:
			return "AmslertestCellGrid"
		case .titleLabel:
			return "AmslertestCellTitle"
		case .split:
			return "AmslertestCellSplit"
		case .splitRadio(.equal):
			return "AmslertestCellSplitEqual"
		case .splitRadio(.better):
			return "AmslertestCellSplitBetter"
		case .splitRadio(.worse):
			return "AmslertestCellSplitWorse"
		case .navigation:
			return "AmslertestCellNavbar"
		}
	}
}
