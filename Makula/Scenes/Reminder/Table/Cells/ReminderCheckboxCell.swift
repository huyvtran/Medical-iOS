import Anchorage
import UIKit

class ReminderCheckboxCell: BaseCell {
	// MARK: - Init

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .default, reuseIdentifier: reuseIdentifier)
		configureView()
	}

	// MARK: - View configuration

	/// The cell's view.
	private let cellView = ReminderCheckboxCellView()

	/**
	 Sets up the view hierarchy and layout.
	 */
	private func configureView() {
		// Embed the view into this cell.
		contentView.addSubview(cellView)
		cellView.edgeAnchors == contentView.edgeAnchors

		// Clear cell background highlight.
		selectedBackgroundView = UIView.viewWithColor(UIColor.clear)
	}

	// MARK: - Setup

	/// The cell's model.
	private var model: ReminderCheckboxCellModel?

	/**
	 Sets up the cell.

	 - parameter model: The cell's model.
	 */
	func setup(model: ReminderCheckboxCellModel) {
		// Apply model.
		self.model = model
		cellView.largeStyle = model.largeStyle
	}

	// MARK: - Cell highlight

	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: false)

		// Apply colors according to state.
		if isSelected {
			cellView.applyHighlightColor()
		} else {
			cellView.applyDefaultColor()
		}
	}

	override func setHighlighted(_ highlighted: Bool, animated: Bool) {
		// Apply colors according to the selected state.
		if isSelected {
			cellView.applyHighlightColor()
		} else {
			cellView.applyDefaultColor()
		}
	}
}
