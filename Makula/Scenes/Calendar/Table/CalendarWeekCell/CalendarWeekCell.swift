import Anchorage
import UIKit

class CalendarWeekCell: BaseCell {
	// MARK: - Init

	public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .default, reuseIdentifier: reuseIdentifier)
		configureView()
	}

	// MARK: - View configuration

	/// The cell's view.
	private let cellView = CalendarWeekCellView()

	/**
	 Sets up the view hierarchy and layout.
	 */
	private func configureView() {
		// Embed the view into this cell.
		contentView.addSubview(cellView)
		cellView.edgeAnchors == contentView.edgeAnchors

		// Disable selection.
		selectionStyle = .none
	}

	// MARK: - Setup

	/// The cell's model.
	private var model: CalendarWeekCellModel?

	/**
	 Sets up the cell.

	 - parameter model: The cell's model.
	 */
	func setup(model: CalendarWeekCellModel) {
		// Apply model.
		self.model = model
		cellView.largeStyle = model.largeStyle
		cellView.date = model.date

		// Apply day label text and color.
		cellView.resetDayLabels()
		if let text = model.monText {
			cellView.setDayLabelTitle(text, atIndex: 0)
		}
		if let color = model.monColor {
			cellView.setDayLabelColor(color, atIndex: 0)
		}
		if let text = model.tueText {
			cellView.setDayLabelTitle(text, atIndex: 1)
		}
		if let color = model.tueColor {
			cellView.setDayLabelColor(color, atIndex: 1)
		}
		if let text = model.wedText {
			cellView.setDayLabelTitle(text, atIndex: 2)
		}
		if let color = model.wedColor {
			cellView.setDayLabelColor(color, atIndex: 2)
		}
		if let text = model.thuText {
			cellView.setDayLabelTitle(text, atIndex: 3)
		}
		if let color = model.thuColor {
			cellView.setDayLabelColor(color, atIndex: 3)
		}
		if let text = model.friText {
			cellView.setDayLabelTitle(text, atIndex: 4)
		}
		if let color = model.friColor {
			cellView.setDayLabelColor(color, atIndex: 4)
		}
		if let text = model.satText {
			cellView.setDayLabelTitle(text, atIndex: 5)
		}
		if let color = model.satColor {
			cellView.setDayLabelColor(color, atIndex: 5)
		}
		if let text = model.sunText {
			cellView.setDayLabelTitle(text, atIndex: 6)
		}
		if let color = model.sunColor {
			cellView.setDayLabelColor(color, atIndex: 6)
		}

		// Register delegate.
		cellView.onDayPressed.setDelegate(to: self) { strongSelf, index in
			model.delegate?.daySelected(onCalendarWeekCell: strongSelf, weekDate: model.date, dayIndex: index)
		}
	}
}
