/// The table controller model of an entry.
struct SearchTableControllerRawEntry {}

/// The diagnosis table cell representations.
enum SearchTableData {
	/// The navigation view as a cell.
	case navigation(NavigationViewCellModel)
	/// The search text field input cell.
	case search
	/// The cell's model to display a result cell and the corresponding info type link.
	case staticText(StaticTextCellModel, InfoType)
}
