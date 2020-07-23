import Anchorage
import UIKit

class ReadingTestMainCell: BaseCell {
	// MARK: - Init

	public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .default, reuseIdentifier: reuseIdentifier)
		configureView()
	}

	// MARK: - View configuration

	/// The cell's view.
	private let cellView = ReadingTestMainCellView()

	/**
	 Sets up the view hierarchy and layout.
	 */
	private func configureView() {
		// Embed the view into this cell.
		contentView.addSubview(cellView)
		cellView.edgeAnchors == contentView.edgeAnchors

		// Disable visible selection.
		selectionStyle = .none
	}

	// MARK: - Setup

	/// The cell's model.
	private var model: ReadingTestMainCellModel?

	/**
	 Sets up the cell.

	 - parameter model: The cell's model.
	 */
	func setup(model: ReadingTestMainCellModel) {
		// Apply model.
		self.model = model
		cellView.largeStyle = model.largeStyle
		cellView.leftSelected = model.leftSelected
		cellView.rightSelected = model.rightSelected
		cellView.contentType = model.magnitudeType

		// Register for callback actions
		cellView.onLeftButtonPressed.setDelegate(to: self, with: { strongSelf, _ in
			model.delegate?.leftButtonPressed(onMainCell: strongSelf, indexPath: model.indexPath)
		})
		cellView.onRightButtonPressed.setDelegate(to: self, with: { strongSelf, _ in
			model.delegate?.rightButtonPressed(onMainCell: strongSelf, indexPath: model.indexPath)
		})
	}
}
