/// The appointment detail table cell representations.
enum AppointmentDetailTableData {
	/// The cell with a static title label.
	case title(StaticTextCellModel)
	/// A split cell showing left and right value.
	case split(SplitCellModel)
	/// The split radio cell for a amslertest progress.
	case amslertestSplitRadio(AmslertestModel, AmslertestProgressType)
	/// The notes cell.
	case note
	/// The delete cell.
	case delete
	/// The navigation view as a cell.
	case navigation
}
