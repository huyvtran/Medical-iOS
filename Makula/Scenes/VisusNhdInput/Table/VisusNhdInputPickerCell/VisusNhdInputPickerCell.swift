import Anchorage
import UIKit

class VisusNhdInputPickerCell: BaseCell {
	// MARK: - Init

	public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .default, reuseIdentifier: reuseIdentifier)
		configureView()
	}

	// MARK: - View configuration

	/// The cell's view.
	private let cellView = VisusNhdInputPickerCellView()

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
	private var model: VisusNhdInputPickerCellModel?

	/**
	 Sets up the cell.

	 - parameter model: The cell's model.
	 */
	func setup(model: VisusNhdInputPickerCellModel) {
		// Apply model.
		self.model = model
		cellView.setType(model.type, value: model.value, largeStyle: model.largeStyle)

		// Register for callback actions
		cellView.valueChangedNotifier.setDelegate(to: self) { strongSelf, value in
			model.delegate?.pickerValueChanged(onVisusNhdInputPickerCell: strongSelf, newValue: value)
		}
	}
}
