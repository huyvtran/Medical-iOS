import Anchorage
import UIKit

class CalendarMonthCell: BaseCell {
	// MARK: - Init

	public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .default, reuseIdentifier: reuseIdentifier)
		configureView()
	}

	// MARK: - View configuration

	/// The cell's view.
	private let cellView = CalendarMonthCellView()

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
	private var model: CalendarMonthCellModel?

	/**
	 Sets up the cell.

	 - parameter model: The cell's model.
	 */
	func setup(model: CalendarMonthCellModel) {
		// Apply model.
		self.model = model
		cellView.largeStyle = model.largeStyle
		cellView.title = model.title
	}
}
