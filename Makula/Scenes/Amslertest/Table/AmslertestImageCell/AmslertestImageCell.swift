import Anchorage
import UIKit

class AmslertestImageCell: BaseCell {
	// MARK: - Init

	public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .default, reuseIdentifier: reuseIdentifier)
		configureView()
	}

	// MARK: - View configuration

	/// The cell's view.
	private let imageCellView = AmslertestImageCellView()

	/**
	 Sets up the view hierarchy and layout.
	 */
	private func configureView() {
		// Embed the main view into this cell.
		contentView.addSubview(imageCellView)
		imageCellView.edgeAnchors == contentView.edgeAnchors

		// Disable selection.
		selectionStyle = .none
	}

	// MARK: - Setup

	/// The cell's model.
	private var model: AmslertestImageCellModel?

	/**
	 Sets up the cell.

	 - parameter model: The cell's model.
	 */
	func setup(model: AmslertestImageCellModel) {
		// Apply model.
		self.model = model
	}
}
