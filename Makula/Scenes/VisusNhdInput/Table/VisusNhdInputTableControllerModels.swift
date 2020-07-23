/// The diagnosis table cell representations.
enum VisusNhdInputTableData {
	/// The navigation view as a cell.
	case navigation(NavigationViewCellModel)
	/// The split cell with an entry to select.
	case split(SplitCellModel)
	/// The picker cell.
	case picker(VisusNhdInputPickerCellModel)
}
