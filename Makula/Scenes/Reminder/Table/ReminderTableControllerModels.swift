/// The table controller model of an entry.
struct ReminderTableControllerRawEntry {}

/// The diagnosis table cell representations.
enum ReminderTableData {
	/// The navigation view as a cell.
	case navigation(NavigationViewCellModel)
	/// The checkbox cell.
	case checkbox
	/// The picker cell.
	case picker
}
